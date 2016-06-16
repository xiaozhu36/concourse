// This file was generated by counterfeiter
package fakes

import (
	"sync"
	"time"

	"github.com/concourse/atc/containerreaper"
	"github.com/concourse/atc/db"
)

type FakeContainerReaperDB struct {
	FindJobIDForBuildStub        func(buildID int) (int, bool, error)
	findJobIDForBuildMutex       sync.RWMutex
	findJobIDForBuildArgsForCall []struct {
		buildID int
	}
	findJobIDForBuildReturns struct {
		result1 int
		result2 bool
		result3 error
	}
	GetContainersWithInfiniteTTLStub        func() ([]db.SavedContainer, error)
	getContainersWithInfiniteTTLMutex       sync.RWMutex
	getContainersWithInfiniteTTLArgsForCall []struct{}
	getContainersWithInfiniteTTLReturns     struct {
		result1 []db.SavedContainer
		result2 error
	}
	UpdateExpiresAtOnContainerStub        func(handle string, ttl time.Duration) error
	updateExpiresAtOnContainerMutex       sync.RWMutex
	updateExpiresAtOnContainerArgsForCall []struct {
		handle string
		ttl    time.Duration
	}
	updateExpiresAtOnContainerReturns struct {
		result1 error
	}
}

func (fake *FakeContainerReaperDB) FindJobIDForBuild(buildID int) (int, bool, error) {
	fake.findJobIDForBuildMutex.Lock()
	fake.findJobIDForBuildArgsForCall = append(fake.findJobIDForBuildArgsForCall, struct {
		buildID int
	}{buildID})
	fake.findJobIDForBuildMutex.Unlock()
	if fake.FindJobIDForBuildStub != nil {
		return fake.FindJobIDForBuildStub(buildID)
	} else {
		return fake.findJobIDForBuildReturns.result1, fake.findJobIDForBuildReturns.result2, fake.findJobIDForBuildReturns.result3
	}
}

func (fake *FakeContainerReaperDB) FindJobIDForBuildCallCount() int {
	fake.findJobIDForBuildMutex.RLock()
	defer fake.findJobIDForBuildMutex.RUnlock()
	return len(fake.findJobIDForBuildArgsForCall)
}

func (fake *FakeContainerReaperDB) FindJobIDForBuildArgsForCall(i int) int {
	fake.findJobIDForBuildMutex.RLock()
	defer fake.findJobIDForBuildMutex.RUnlock()
	return fake.findJobIDForBuildArgsForCall[i].buildID
}

func (fake *FakeContainerReaperDB) FindJobIDForBuildReturns(result1 int, result2 bool, result3 error) {
	fake.FindJobIDForBuildStub = nil
	fake.findJobIDForBuildReturns = struct {
		result1 int
		result2 bool
		result3 error
	}{result1, result2, result3}
}

func (fake *FakeContainerReaperDB) GetContainersWithInfiniteTTL() ([]db.SavedContainer, error) {
	fake.getContainersWithInfiniteTTLMutex.Lock()
	fake.getContainersWithInfiniteTTLArgsForCall = append(fake.getContainersWithInfiniteTTLArgsForCall, struct{}{})
	fake.getContainersWithInfiniteTTLMutex.Unlock()
	if fake.GetContainersWithInfiniteTTLStub != nil {
		return fake.GetContainersWithInfiniteTTLStub()
	} else {
		return fake.getContainersWithInfiniteTTLReturns.result1, fake.getContainersWithInfiniteTTLReturns.result2
	}
}

func (fake *FakeContainerReaperDB) GetContainersWithInfiniteTTLCallCount() int {
	fake.getContainersWithInfiniteTTLMutex.RLock()
	defer fake.getContainersWithInfiniteTTLMutex.RUnlock()
	return len(fake.getContainersWithInfiniteTTLArgsForCall)
}

func (fake *FakeContainerReaperDB) GetContainersWithInfiniteTTLReturns(result1 []db.SavedContainer, result2 error) {
	fake.GetContainersWithInfiniteTTLStub = nil
	fake.getContainersWithInfiniteTTLReturns = struct {
		result1 []db.SavedContainer
		result2 error
	}{result1, result2}
}

func (fake *FakeContainerReaperDB) UpdateExpiresAtOnContainer(handle string, ttl time.Duration) error {
	fake.updateExpiresAtOnContainerMutex.Lock()
	fake.updateExpiresAtOnContainerArgsForCall = append(fake.updateExpiresAtOnContainerArgsForCall, struct {
		handle string
		ttl    time.Duration
	}{handle, ttl})
	fake.updateExpiresAtOnContainerMutex.Unlock()
	if fake.UpdateExpiresAtOnContainerStub != nil {
		return fake.UpdateExpiresAtOnContainerStub(handle, ttl)
	} else {
		return fake.updateExpiresAtOnContainerReturns.result1
	}
}

func (fake *FakeContainerReaperDB) UpdateExpiresAtOnContainerCallCount() int {
	fake.updateExpiresAtOnContainerMutex.RLock()
	defer fake.updateExpiresAtOnContainerMutex.RUnlock()
	return len(fake.updateExpiresAtOnContainerArgsForCall)
}

func (fake *FakeContainerReaperDB) UpdateExpiresAtOnContainerArgsForCall(i int) (string, time.Duration) {
	fake.updateExpiresAtOnContainerMutex.RLock()
	defer fake.updateExpiresAtOnContainerMutex.RUnlock()
	return fake.updateExpiresAtOnContainerArgsForCall[i].handle, fake.updateExpiresAtOnContainerArgsForCall[i].ttl
}

func (fake *FakeContainerReaperDB) UpdateExpiresAtOnContainerReturns(result1 error) {
	fake.UpdateExpiresAtOnContainerStub = nil
	fake.updateExpiresAtOnContainerReturns = struct {
		result1 error
	}{result1}
}

var _ containerreaper.ContainerReaperDB = new(FakeContainerReaperDB)
