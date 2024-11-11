Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646AD2B9A9;
	Mon, 11 Nov 2024 10:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731321433; cv=none; b=IwQlhZax0JkrD1FWpUyzM+crOmjMNMwUN+6i41u3xKgAOr9uSRLd5GgryCQp8+m15BJNdtDyrlOCgDUcVbc2rKIttCTy6GpV1Prhy/M0Y/aTSeip0irfWTc9MVln1kR2+qC8zgZuGpaPzBantYmAAvAtEqgLx30TK9db4MbZKt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731321433; c=relaxed/simple;
	bh=P4AaAvIbVWhclYykSBnt3aFnOH4jiTuUtEOJcfctRgM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lKKOQXw4RXQavZ7w+47xT2ymNgmySX5SHYbeGQHNHOMpm8p7gKVMNiVSTMWO0KJ7i201FcMNuCl636mQJ0vrGwdusXzzx1HrfJmQC3yD4lla8/9PKlrT+ZlCKSW88tGT/BW8yM/PjSFS+FdLchChibxZaSNge8ABIH4sAZbt2sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=GyegV+ae; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=VUr+ZHPB; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="GyegV+ae";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="VUr+ZHPB"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com B58D3E0003
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1731320893; bh=P4AaAvIbVWhclYykSBnt3aFnOH4jiTuUtEOJcfctRgM=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version:From;
	b=GyegV+aee58DzkfNlXRFoF4adTSRQXWZ3ii6b0PfqTI8e3bn9qK8fnmS6SsyVz+pm
	 x8FgYoPdue0+yiaDinbTvRFdItmT3idD/HbfVLKBSZW+Nd/40HQWw9oHCZWmsjFYeS
	 68LSBe0kCBq80fji/QT9iCBSCNPqUy1CcyO5pqXIf4mhMwaVA/7Dh1v9/wsa1I/8G8
	 p479qpaNpDv0/jIQdPeSNP4/2VkQp7DXW9jkjXjTuWboLdTwEc6f143GxQ79RoDtvc
	 LG8r94N+Xm0sDUN+gju2AP5r8UdpuL+UCugDT5S4KEUW3bFfCe/UeuVm/sSpvCAGb7
	 s7GMO0qoWeq0w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1731320893; bh=P4AaAvIbVWhclYykSBnt3aFnOH4jiTuUtEOJcfctRgM=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version:From;
	b=VUr+ZHPBfcAaqAs/wtG98BsE2/rvkQjhwqZVNKFQJoJex+Nlj3DAZlrABkLMG9/zv
	 ImfgEluhbllTijEtQeo070KVmMDM/CoFMaSgYccZ1vTyRR1K3BlrfYQZW7JRCgTeJi
	 yvDCMogZMV1rzmIcvspOakBkhnAO9jRH7BZQeNfxexHrR5NdXnyrp4aSo14Lr5CS+b
	 9q8tkSfV8BBFymvLHLmPS6ESvx5mb9hOLPs4d1Rs65DFzwm1VLoDJvU2MiTs6Siud8
	 N9FQNwJzSGOUCyfJg/OS/az5wnWg+he4NOCcldfQ0IYXhn4FffyXoi8qErSKjOvsfH
	 Et9KlKTjn3sWA==
From: Anastasia Kovaleva <a.kovaleva@yadro.com>
To: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
	"njavali@marvell.com" <njavali@marvell.com>,
	"GR-QLogic-Storage-Upstream@marvell.com"
	<GR-QLogic-Storage-Upstream@marvell.com>
CC: "James.Bottomley@HansenPartnership.com"
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
Thread-Index: AQHbGzIvZMV/oTAyUkWQTinjaU2zibKiTS4AgA/FPwA=
Date: Mon, 11 Nov 2024 10:28:12 +0000
Message-ID: <021F3B9D-6DD0-4DD8-BDF0-D7D1A633621D@yadro.com>
References: <20241010163236.27969-1-a.kovaleva@yadro.com>
 <93FA6AD1-9959-4E4C-A447-9CF694A6A024@yadro.com>
In-Reply-To: <93FA6AD1-9959-4E4C-A447-9CF694A6A024@yadro.com>
Accept-Language: ru-RU, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="utf-8"
Content-ID: <359718AC88BC8847AB811981A58BCAAC@yadro.com>
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
dmEgKDMpOg0KPiBzY3NpOiBxbGEyeHh4OiBEcm9wIHN0YXJ2YXRpb24gY291bnRlciBvbiBzdWNj
ZXNzDQo+IHNjc2k6IHFsYTJ4eHg6IE1ha2UgdGFyZ2V0IHNlbmQgY29ycmVjdCBMT0dPDQo+IHNj
c2k6IHFsYTJ4eHg6IFJlbW92ZSBpbmNvcnJlY3QgdHJhcA0KPg0KPiBkcml2ZXJzL3Njc2kvcWxh
Mnh4eC9xbGFfaW9jYi5jIHwgMTEgKysrKysrKysrKysNCj4gZHJpdmVycy9zY3NpL3FsYTJ4eHgv
cWxhX2lzci5jIHwgNCArKysrDQo+IGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV90YXJnZXQuYyB8
IDE2ICsrKysrKystLS0tLS0tLS0NCj4gMyBmaWxlcyBjaGFuZ2VkLCAyMiBpbnNlcnRpb25zKCsp
LCA5IGRlbGV0aW9ucygtKQ0KPg0KDQoNCkdlbnRsZSBwaW5nDQoNCg0KDQoNCg0K
