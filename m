From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 1/3] mpt2sas: remove the use of writeq, since writeq is
 not atomic
Date: Wed, 18 May 2011 16:05:58 -0600
Message-ID: <4565AEA676113A449269C2F3A549520F80BE7FAF@cosmail03.lsi.com>
References: <20110504115324.GE17855@lsi.com>
	 <1305616571.6008.23.camel@mulgrave.site>
	 <B2FD678A64EAAD45B089B123FDFC3ED70157F7BCE5@inbmail01.lsi.com>
	 <20110518041551.GL15227@parisc-linux.org>
	 <1305692584.2580.3.camel@mulgrave.site>	<1305702010.2781.33.camel@pasglop>
	 <mpt2sas-writeq-powerpc64@mdm.bga.com>
	 <4565AEA676113A449269C2F3A549520F80B66280@cosmail03.lsi.com>
 <1305754218.7481.0.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:45992 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754446Ab1ERWGC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2011 18:06:02 -0400
In-Reply-To: <1305754218.7481.0.camel@pasglop>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Milton Miller <miltonm@bga.com>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Wilcox <matthew@wil.cx>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "paulus@samba.org" <paulus@samba.org>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>

T24gV2VkbmVzZGF5LCBNYXkgMTgsIDIwMTEgMzozMCBQTSwgQmVuamFtaW4gSGVycmVuc2NobWlk
dCB3cm90ZToNCj4gDQo+IFlvdSBtYXkgYWxzbyB3YW50IHRvIGxvb2sgYXQgTWlsdG9uJ3MgY29t
bWVudHMsIGl0IGxvb2tzIGxpa2UgdGhlIHdheQ0KPiB5b3UgZG8gaW5pdF9jb21wbGV0aW9uIGZv
bGxvd2VkIGltbWVkaWF0ZWx5IGJ5IHdhaXRfY29tcGxldGlvbiBpcyByYWN5Lg0KPiANCj4gWW91
IHNob3VsZCBpbml0IHRoZSBjb21wbGV0aW9uIGJlZm9yZSB5b3UgZG8gdGhlIElPIHRoYXQgd2ls
bCBldmVudHVhbGx5DQo+IHRyaWdnZXIgY29tcGxldGUoKSB0byBiZSBjYWxsZWQuDQo+IA0KDQpJ
IGFncmVlLiAgVGhlIGluaXRfY29tcGxldGlvbiBuZWVkcyB0byBiZSBkb25lIHByaW9yIHRvIHBv
c3RpbmcgdGhlIHNtaWQuICBJJ20gbm90IHN1cmUgd2h5IEkgZGlkIGl0IHRoYXQgd2F5Lg0K
