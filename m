Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E017115AAB6;
	Fri,  1 Nov 2024 09:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730453917; cv=none; b=Euz30xZ1AQNV2JLw5Ms4HMEKiAHiFEZIcoIwnbSBOPyK29CwrIyxeVlGuDk2PhGPkk8e8ngJJm4AW/nxrwvZd7NChJVH+QcpayokvKIawjT+AFCbQbTCNSBhtKAQcrwyqI7Th41xGpx5yJCT+44+QgJnH8P/haPQnPyC/8NmtGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730453917; c=relaxed/simple;
	bh=5UH5ZYO1q7g1Z8k4/mlpRUHrS+F7qL+lbeCgu/TgPZk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jQmVBLzs3eE3AKBvoCK2gAVOBFa7Pnbd+yxFaMveGJnb9VH5koZ1T9Om7IKAYMSgXYicSuZE096U2uyMiTKke0ahE6+QTKT0BERLUekP2QujbKUmCf0ZkhBnT9DTyQYY/kLiNmT1TkkVcPQnDbTyM+tOxnaKyTOwy3eJsF0VYDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=WYKhduho; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=IpSDNkeo; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="WYKhduho";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="IpSDNkeo"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com 6DD92E0002
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1730453901; bh=5UH5ZYO1q7g1Z8k4/mlpRUHrS+F7qL+lbeCgu/TgPZk=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version:From;
	b=WYKhduho3ag/SWd4IKqjFmP5Xen8eB8RGepp0pcrL7H+utEIRZQ74ly2LF5KeJ+sW
	 880P9mLuBRoSI9ztW4JmJMYf+fR4lB/BgdAVpHJig2Ta3ud2lZSnnuBWRhS/+0YCWg
	 c83/hlB2gpUtYuUdZe/LWQKs52G2nlavKo1YlCV/zBMpH7gzXvc7yqqAei++YW3CzM
	 pQLVSLXS5Bf6r+ZiB7PleOmPsYunG008VBbcVVd0+DBd+tcF7uR/qUnzQMbaGmRKfN
	 f8QkePiesdZt3MSRWJanzrrDMAkrzxS3jJ69yMfNQpGN0zXnJR6TdysjyqVdSAqT+u
	 M6ho4E5NdmBHA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1730453901; bh=5UH5ZYO1q7g1Z8k4/mlpRUHrS+F7qL+lbeCgu/TgPZk=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version:From;
	b=IpSDNkeoeYK2uEMJgfoSj8SIdfXHu5fi4gZP/j5YGdb1JNVTWj6zD2WmnJJu2Py6x
	 tRnENn7aFHf2is4k5DYD501J74gtXaM1ktiTKYsEYbKUw4DYWrl9dMfJpxA7nrOfIx
	 86+GnH8Eg5Y+EatVExHqYdUYC9H2vlog02D6LiThtZKgVZNvU4b26nAv1tYSyULSJ+
	 RLWShKWl7ZKkwes1hZEgkM/nri9rJ40EXCKljvbVhNsA5dTWwMwMAgjjHE8LMJIXpu
	 YRWBJ691MipvR80kgcpyeaO7le7VhRM/A6ytjBkH67qQk0OSrzrRD9ELLHWSTSeYdH
	 pB52pYI+dHhkA==
From: Anastasia Kovaleva <a.kovaleva@yadro.com>
To: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC: "njavali@marvell.com" <njavali@marvell.com>,
	"GR-QLogic-Storage-Upstream@marvell.com"
	<GR-QLogic-Storage-Upstream@marvell.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"quinn.tran@cavium.com" <quinn.tran@cavium.com>,
	"himanshu.madhani@oracle.com" <himanshu.madhani@oracle.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux@yadro.com" <linux@yadro.com>, "hare@suse.de" <hare@suse.de>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3 0/3] Fix bugs in qla2xxx driver
Thread-Topic: [PATCH v3 0/3] Fix bugs in qla2xxx driver
Thread-Index: AQHbGzIvZMV/oTAyUkWQTinjaU2zibKiTS4A
Date: Fri, 1 Nov 2024 09:38:20 +0000
Message-ID: <93FA6AD1-9959-4E4C-A447-9CF694A6A024@yadro.com>
References: <20241010163236.27969-1-a.kovaleva@yadro.com>
In-Reply-To: <20241010163236.27969-1-a.kovaleva@yadro.com>
Accept-Language: ru-RU, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="utf-8"
Content-ID: <90F19368F5ECAC4B88EE53A71DD7A831@yadro.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gVGh1LCAxMCBPY3QgMjAyNCAxOTozMjozMyArMDMwMCwgQW5hc3Rhc2lhIEtvdmFsZXZhIHdy
b3RlOg0KPiBUaGlzIHNlcmllcyBvZiBwYXRjaGVzIGNvbnRhaW5zIDMgc2VwYXJhdGUgY2hhbmdl
cyB0aGF0IGZpeCBzb21lIGJ1Z3MgaW4NCj4gdGhlIHFsYTJ4eHggZHJpdmVyLg0KPiAtLS0NCj4g
djM6DQo+IC0gRml4IGJ1aWxkIGlzc3VlIGluIHBhdGNoIDENCj4gdjI6DQo+IC0gQ2hhbmdlIGEg
c3BpbmxvY2sgd3JhcCB0byBhIFdSSVRFX09OQ0UoKSBpbiBwYXRjaCAxDQo+IC0gQWRkIFJldmll
d2VkLWJ5IHRhZ3Mgb24gcGF0Y2hlcyAyIGFuZCAzDQo+IC0tLQ0KPiBBbmFzdGFzaWEgS292YWxl
dmEgKDMpOg0KPiAgICBzY3NpOiBxbGEyeHh4OiBEcm9wIHN0YXJ2YXRpb24gY291bnRlciBvbiBz
dWNjZXNzDQo+ICAgIHNjc2k6IHFsYTJ4eHg6IE1ha2UgdGFyZ2V0IHNlbmQgY29ycmVjdCBMT0dP
DQo+ICAgIHNjc2k6IHFsYTJ4eHg6IFJlbW92ZSBpbmNvcnJlY3QgdHJhcA0KPg0KPiAgIGRyaXZl
cnMvc2NzaS9xbGEyeHh4L3FsYV9pb2NiLmMgICB8IDExICsrKysrKysrKysrDQo+ICAgZHJpdmVy
cy9zY3NpL3FsYTJ4eHgvcWxhX2lzci5jICAgIHwgIDQgKysrKw0KPiAgIGRyaXZlcnMvc2NzaS9x
bGEyeHh4L3FsYV90YXJnZXQuYyB8IDE2ICsrKysrKystLS0tLS0tLS0NCj4gICAzIGZpbGVzIGNo
YW5nZWQsIDIyIGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0pDQo+DQoNCkdlbnRsZSBwaW5n
DQoNCg==
