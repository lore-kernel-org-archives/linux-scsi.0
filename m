From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 3/4] qla2xxx: Add Block Multi Queue functionality.
Date: Tue, 8 Nov 2016 17:37:59 +0000
Message-ID: <074728C7-4065-4A86-8AB1-2E3E1471A887@cavium.com>
References: <1478277213-3848-1-git-send-email-himanshu.madhani@cavium.com>
 <1478277213-3848-4-git-send-email-himanshu.madhani@cavium.com>
 <1478537008.32271.43.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0073.outbound.protection.outlook.com ([104.47.32.73]:43712
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753152AbcKHTLZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Nov 2016 14:11:25 -0500
In-Reply-To: <1478537008.32271.43.camel@localhost.localdomain>
Content-Language: en-US
Content-ID: <C75B37B2C0081349B19935B6C171295F@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "emilne@redhat.com" <emilne@redhat.com>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "himanshu.madhani@qlogic.com" <himanshu.madhani@qlogic.com>

SGkgRXdhbiwNCg0KDQoNCk9uIDExLzcvMTYsIDg6NDMgQU0sICJFd2FuIEQuIE1pbG5lIiA8ZW1p
bG5lQHJlZGhhdC5jb20+IHdyb3RlOg0KDQo+T24gRnJpLCAyMDE2LTExLTA0IGF0IDA5OjMzIC0w
NzAwLCBoaW1hbnNodS5tYWRoYW5pQGNhdml1bS5jb20gd3JvdGU6DQo+PiBGcm9tOiBNaWNoYWVs
IEhlcm5hbmRleiA8bWljaGFlbC5oZXJuYW5kZXpAY2F2aXVtLmNvbT4NCj4+IA0KPj4gVGVsbCB0
aGUgU0NTSSBsYXllciBob3cgbWFueSBoYXJkd2FyZSBxdWV1ZXMgd2UgaGF2ZSBiYXNlZCBvbiB0
aGUNCj4+IG51bWJlciBvZiBtYXggcXVldWUgcGFpcnMgY3JlYXRlZC4gVGhlIG51bWJlciBvZiBt
YXggcXVldWUgcGFpcnMNCj4+IGNyZWF0ZWQgd2lsbCBkZXBlbmQgb24gbnVtYmVyIG9mIE1TSSBY
IHZlY3RvciBjb3VudCBvciBudW1iZXIgb2YgQ1BVJ3MNCj4+IGluIGEgc3lzdGVtLg0KPj4gDQo+
PiBUaGlzIGZlYXR1cmUgY2FuIGJlIHR1cm5lZCBvbiB2aWEgQ09ORklHX1NDU0lfTVFfREVGQVVM
VCBvciBwYXNzaW5nDQo+PiBzY3NpX21vZC51c2VfYmxrX21xPVkgYXMgYSBwYXJhbWV0ZXIgdG8g
dGhlIGtlcm5lbA0KPj4gUXVldWUgcGFpciBjcmVhdGlvbiBkZXBlbmQgb24gbW9kdWxlIHBhcmFt
ZXRlciAicWwyeG1xc3VwcG9ydCIsIHdoaWNoDQo+PiBuZWVkIHRvIGJlIGVuYWJsZWQgdG8gY3Jl
YXRlIHF1ZXVlIHBhaXIuDQo+PiANCj4NCj5JIGRvbid0IHVuZGVyc3RhbmQgdGhpcyBjaGFuZ2Ug
YXQgYWxsLiAgU2V0dGluZyAtPm5yX2h3X3F1ZXVlcyBjYXVzZXMNCj50aGUgYmxvY2sgbGF5ZXIg
dG8gYWxsb2NhdGUgYSBudW1iZXIgb2YgcXVldWVzIGZvciB0aGF0IFNjc2lfSG9zdA0KPm9iamVj
dCwgYnV0IGl0IGRvZXMgbm90IGFwcGVhciBhcyBpZiB0aGlzIGNvZGUgdXNlcyB0aGF0IGZ1bmN0
aW9uYWxpdHkuDQo+VGhlcmUgaXMgbm90aGluZyBpbiB0aGUgcGF0Y2ggdGhhdCBleGFtaW5lcyB0
aGUgdGFnIHRvIHNlZSB3aGljaCBxdWV1ZQ0KPnRoZSByZXF1ZXN0IGNhbWUgaW4gb24sIGluIG9y
ZGVyIHRvIG1hcCBpdCB0byBhIGhhcmR3YXJlIHF1ZXVlLg0KPg0KPkluc3RlYWQsIHRoaXMgcGF0
Y2ggc2VlbXMgdG8gYmUgcmV3b3JraW5nIHRoZSBtZWNoYW5pc20gaW52b2x2ZWQgaW4NCj5OUElW
IHZwb3J0IGNyZWF0aW9uLCB3aGljaCBjcmVhdGVzIGFuIGVudGlyZWx5IHNlcGFyYXRlIFNjc2lf
SG9zdA0KPm9iamVjdC4gIFRoZSBkcml2ZXIgd2FzIGFscmVhZHkgY3JlYXRpbmcgc2VwYXJhdGUg
cmVxdWVzdCBxdWV1ZXMgdG8NCj50aGUgY2FyZCBmb3IgdnBvcnRzLCBzbyB3aGF0IGRvZXMgdGhp
cyBoYXZlIHRvIGRvIHdpdGggQmxvY2stTVE/DQoNClRoYW5rcyBmb3IgdGhlIHJldmlldyBjb21t
ZW50cy4gV2UgYXJlIHJld29ya2luZyBwYXRjaCBzZXJpZXMgdG8gYWRkcmVzcyANCnlvdXIgcmV2
aWV3IGNvbW1lbnRzLiANCg0KPg0KPi1Fd2FuDQo+IA0KPg0KDQpUaGFua3MsDQpIaW1hbnNodQ0K
