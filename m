Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01599AD2D;
	Tue,  1 Apr 2025 03:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743478344; cv=none; b=l8sGZRpS7azjPC8/Ff4CNc0F/E0XBzZT2LbgU2L248S8OvdJkiWjmMqZ38G01DeYF8b8e4ewyCvnmZZAr2fJ/gxWHRzjhxEzdhSUYa0ccdOR265BeruS2S/WoIyV7Hm2HaabSr7kSkmIiEJskDVIBNSdwB9vfKlcfrOsRXlFX08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743478344; c=relaxed/simple;
	bh=0SpQ7LEAcrFiz5h9E6eJe0iEGUTS9H3xU0FK0F2A5/8=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=s6jJg0/kCnNInn5Qc4ck0lPTh+9Q5OWkJVTf4HJsBq4d5Yr55xSF7X1SBLIWSwVQyVavPN1Jryn7AitJkqavUPvaBjdRgXZ/6Ax0ohBVNtLfhBZHr9DWa6NxSbY00RWEHPPphHJ4tX+PrpDr2N6UZH78z5TLBXDzpx7ChEDHxpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4ZRYMx4wq4z1k0WJ;
	Tue,  1 Apr 2025 11:27:25 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 357CE1A0188;
	Tue,  1 Apr 2025 11:32:12 +0800 (CST)
Received: from dggpemf500016.china.huawei.com (7.185.36.197) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 1 Apr 2025 11:32:11 +0800
Received: from dggpemf500016.china.huawei.com ([7.185.36.197]) by
 dggpemf500016.china.huawei.com ([7.185.36.197]) with mapi id 15.02.1544.011;
 Tue, 1 Apr 2025 11:32:11 +0800
From: Jiangjianjun <jiangjianjun3@huawei.com>
To: John Garry <john.g.garry@oracle.com>
CC: "jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, lixiaokeng <lixiaokeng@huawei.com>,
	"hewenliang (C)" <hewenliang4@huawei.com>, "Yangkunlin(Poincare)"
	<yangkunlin7@huawei.com>, yangxingui <yangxingui@huawei.com>, "liyihang (C)"
	<liyihang9@huawei.com>
Subject: reply: reply: [RFC PATCH v3 00/19] scsi: scsi_error: Introduce new
 error handle mechanism
Thread-Topic: reply: reply: [RFC PATCH v3 00/19] scsi: scsi_error: Introduce
 new error handle mechanism
Thread-Index: AduithEq+m5LtS6wQaGgJklvwSH4ng==
Date: Tue, 1 Apr 2025 03:32:11 +0000
Message-ID: <598173fee9844be9ba19bfed35be2f5c@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

DQpPbiAzMS8wMy8yMDI1IDA0OjEwLCBKaWFuZ2ppYW5qdW4gd3JvdGU6DQo+IFNvcnJ5IGZvciBs
YXRlIG1lc3NhZ2UhIEknbSB3b3JraW5nIG9uIGZpeGluZyBhbmQgdGVzdGluZyB0aGVzZSBpc3N1
ZXMgYmVmb3JlIHJlLWVtYWlsaW5nLg0KDQpXaGF0IGFyZSB5b3UgYWN0dWFsbHkgd29ya2luZyBv
bj8NCg0KSXQgc2VlbXMgdGhhdCBIYW5uZXMnICJzY3NpOiBFSCByZXdvcmssIG1haW4gcGFydCIg
c2VyaWVzIGFuZCBtYXliZSB0aGlzIG9uZSBjYW4gaGVscCByZXNvbHZlIHRoaXMgZm9sbG93aW5n
IGlzc3VlOg0KDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1ibG9jay9lZWYxZTkyNy1j
OWIyLWM2MWQtN2Y0OC05MmU2NWQ4YjA0MThAaHVhd2VpLmNvbS8NCg0Kd2l0aCBmaXggYXR0ZW1w
dGVkIGluOg0KDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1pZGUvMjAyNDEwMzExNDA3
MzEuMjI0NTg5LTQtY2Fzc2VsQGtlcm5lbC5vcmcvDQoNCnNvIHRoYXQgd2UgZG9uJ3Qgc2VlICJm
aXhlcyIgbGlrZToNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LXNjc2kvMjAyNTAzMjkw
NzMyMzYuMjMwMDU4Mi0xLWxpeWloYW5nOUBodWF3ZWkuY29tL1QvI204MGJjYjNmNTdmZDE3NmI3
Y2U0MWIxZjI2ZTg1NjBkZTZhZDUyYzlkDQoNCj4gDQo+IC0tLS0t6YKu5Lu25Y6f5Lu2LS0tLS0N
Cj4g5Y+R5Lu25Lq6OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGluZnJhZGVhZC5vcmc+DQo+IOWP
kemAgeaXtumXtDogMjAyNeW5tDPmnIgyMOaXpSAxNDowNg0KPiDmlLbku7bkuro6IEhhbm5lcyBS
ZWluZWNrZSA8aGFyZUBzdXNlLmRlPg0KPiDmioTpgIE6IEppYW5namlhbmp1biA8amlhbmdqaWFu
anVuM0BodWF3ZWkuY29tPjsgamVqYkBsaW51eC5pYm0uY29tOyANCj4gbWFydGluLnBldGVyc2Vu
QG9yYWNsZS5jb207IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnOyANCj4gbGludXgta2VybmVs
QHZnZXIua2VybmVsLm9yZzsgbGl4aWFva2VuZyA8bGl4aWFva2VuZ0BodWF3ZWkuY29tPjsgDQo+
IGhld2VubGlhbmcgKEMpIDxoZXdlbmxpYW5nNEBodWF3ZWkuY29tPjsgWWFuZ2t1bmxpbihQb2lu
Y2FyZSkgDQo+IDx5YW5na3VubGluN0BodWF3ZWkuY29tPg0KPiDkuLvpopg6IFJlOiBbUkZDIFBB
VENIIHYzIDAwLzE5XSBzY3NpOiBzY3NpX2Vycm9yOiBJbnRyb2R1Y2UgbmV3IGVycm9yIA0KPiBo
YW5kbGUgbWVjaGFuaXNtDQo+IA0KPiBPbiBGcmksIE1hciAxNCwgMjAyNSBhdCAxMDowMTo0MEFN
ICswMTAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6DQo+PiAzLiBUaGUgY3VycmVudCBFSCBmcmFt
ZXdvcmsgaXMgZGVzaWduZWQgYXJvdW5kICdzdHJ1Y3Qgc2NzaV9jbW5kJy4NCj4+IFdoaWNoIG1l
YW5zIHRoYXQgdGhlIGNvbW1hbmQgX2luaXRpYXRpbmdfIHRoZSBlcnJvciBoYW5kbGluZyBjYW4g
b25seSANCj4+IGJlIHJldHVybmVkIG9uY2UgdGhlIF9lbnRpcmVfIGVycm9yIGhhbmRsaW5nICh3
aXRoIGFsbA0KPj4gZXNjYWxhdGlvbnMpIGlzIGZpbmlzaGVkLiBBbmQgbW9yZSBvZnRlbiB0aGFu
IG5vdCwgdGhlIGFwcGxpY2F0aW9uIGlzIA0KPj4gd2FpdGluZyBvbiB0aGF0IGNvbW1hbmQgdG8g
YmUgY29tcGxldGVkIGJlZm9yZSB0aGUgbmV4dCBJL08gaXMgc2VudC4NCj4+IEFuZCB0aGF0IHJl
YWxseSBsaW1pdHMgdGhlIGVmZmVjdGl2ZW5lc3Mgb2YgYW55IGltcHJvdmVkIGVycm9yIA0KPj4g
aGFuZGxlcjsgdGhlIGFwcGxpY2F0aW9uIHVsdGltYXRpdmVseSBoYXMgdG8gd2FpdCBmb3IgYSBo
b3N0IHJlc2V0IA0KPj4gYmVmb3JlIGl0IGNhbiBjb250aW5lLg0KPiANCj4gQW5kIHNvbWVvbmUg
bmVlZHMgdG8gZ2V0IHlvdXIgb2xkIHNlcmllcyB0byBmaXggdGhhdCBtZXJnZWQgYmVmb3JlIHdl
IGV2ZW4gc3RhcnQgdGFsa2luZyBhYm91dCBhbnkgbWFqb3IgRUggY2hhbmdlLg0KPiANCg0KU29y
cnksIHRoZSBwcmV2aW91cyBlbmdpbmVlciBXZW4gQ2hhbydzIHdvcmsgaGFzIGNoYW5nZWQuIE5v
dyBJIHdpbGwgY29udGludWUgdG8gY29tcGxldGUgdGhpcyB3b3JrLiBJbiB0aGUgZnV0dXJlLg0K
SSB3aWxsIGFuYWx5emUgdGhlIGRldGFpbHMgb2YgdGhlIHNvbHV0aW9uLCBpbXByb3ZlIGFuZCBy
ZWZpbmUgdGhlIGFib3ZlIHN1Z2dlc3Rpb25zLCBhbmQgY2FyZWZ1bGx5IHN1Ym1pdCB0aGUgZW1h
aWwuDQoNCg==
