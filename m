From: "Achim Leubner" <Achim_Leubner@pmc-sierra.com>
Subject: RE: [patch] aacraid: controller hangs if kernel uses non-default ASPM policy
Date: Fri, 11 Nov 2011 04:36:45 -0800
Message-ID: <FD2BDBE06AC58549AE9E16C08B45675D0607BB3B@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
References: <4EBCEDF8.2090403@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:53182 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757263Ab1KKMgs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Nov 2011 07:36:48 -0500
Content-class: urn:content-classes:message
In-Reply-To: <4EBCEDF8.2090403@parallels.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasily Averin <vvs@parallels.com>, linux-scsi@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, James Bottomley <jbottomley@parallels.com>, Mark Salyzyn <mark_salyzyn@us.xyratex.com>

QWNrZWQtYnk6IEFjaGltIExldWJuZXIgPEFjaGltX0xldWJuZXJAcG1jLXNpZXJyYS5jb20+DQoN
Cg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IGxpbnV4LXNjc2ktb3duZXJAdmdl
ci5rZXJuZWwub3JnIFttYWlsdG86bGludXgtc2NzaS1vd25lckB2Z2VyLmtlcm5lbC5vcmddIE9u
IEJlaGFsZiBPZiBWYXNpbHkgQXZlcmluDQpTZW50OiBGcmVpdGFnLCAxMS4gTm92ZW1iZXIgMjAx
MSAxMDo0Mg0KVG86IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnOyBBZGFwdGVjIE9FTSBSYWlk
IFNvbHV0aW9ucw0KQ2M6IE1hdHRoZXcgR2FycmV0dDsgSmFtZXMgQm90dG9tbGV5OyBNYXJrIFNh
bHl6eW4NClN1YmplY3Q6IFtwYXRjaF0gYWFjcmFpZDogY29udHJvbGxlciBoYW5ncyBpZiBrZXJu
ZWwgdXNlcyBub24tZGVmYXVsdCBBU1BNIHBvbGljeQ0KDQpQYXRjaCBmcm9tIFJIRUw2IGtlcm5l
bA0KLSBbc2NzaV0gYWFjcmFpZDogRGlzYWJsZSBBU1BNIGJ5IGRlZmF1bHQgKE1hdHRoZXcgR2Fy
cmV0dCkgWzU5OTczNV0NCmFhY3JhaWQgY29udHJvbGxlciBoYW5ncyBpZiBrZXJuZWwgdXNlcyBu
b24tZGVmYXVsdCBBU1BNIHBvbGljeQ0KDQpTaWduZWQtb2ZmLWJ5OglWYXNpbHkgQXZlcmluIDx2
dnNAc3cucnU+DQpDQzogTWF0dGhldyBHYXJyZXR0IDxtamdAcmVkaGF0LmNvbT4NCg==
