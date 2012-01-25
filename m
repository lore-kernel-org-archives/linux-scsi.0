From: "Loke, Chetan" <Chetan.Loke@netscout.com>
Subject: RE: [Lsf-pc] [dm-devel]  [LSF/MM TOPIC] a few storage topics
Date: Wed, 25 Jan 2012 13:37:16 -0500
Message-ID: <D3F292ADF945FB49B35E96C94C2061B915A63A50@nsmail.netscout.com>
References: <20120124151504.GQ4387@shiny> <20120124165631.GA8941@infradead.org> <186EA560-1720-4975-AC2F-8C72C4A777A9@dilger.ca> <x49fwf5kmbl.fsf@segfault.boston.devel.redhat.com> <20120124184054.GA23227@infradead.org> <20120124190732.GH4387@shiny> <x49vco0kj5l.fsf@segfault.boston.devel.redhat.com> <20120124200932.GB20650@quack.suse.cz> <x49pqe8kgej.fsf@segfault.boston.devel.redhat.com> <20120124203936.GC20650@quack.suse.cz> <20120125032932.GA7150@localhost> <F6F2DEB8-F096-4A3B-89E3-3A132033BC76@dilger.ca> <1327502034.2720.23.camel@menhir> <D3F292ADF945FB49B35E96C94C2061B915A638A6@nsmail.netscout.com> <1327509623.2720.52.camel@menhir> <1327512727.2776.52.camel@dabdike.int.hansenpartnership.com> <D3F292ADF945FB49B35E96C94C2061B915A63A30@nsmail.netscout.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod6og104.obsmtp.com ([64.18.1.187]:34510 "HELO
	exprod6og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750876Ab2AYShS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2012 13:37:18 -0500
Content-class: urn:content-classes:message
In-Reply-To: <D3F292ADF945FB49B35E96C94C2061B915A63A30@nsmail.netscout.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Steven Whitehouse <swhiteho@redhat.com>
Cc: Andreas Dilger <adilger@dilger.ca>, Wu Fengguang <fengguang.wu@gmail.com>, Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, neilb@suse.de, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Boaz Harrosh <bharrosh@panasas.com>, linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, Chris Mason <chris.mason@oracle.com>, "Darrick J.Wong" <djwong@us.ibm.com>, linux-mm@kvack.org

PiANCj4gPiBTbyB0aGVyZSBhcmUgdHdvIHNlcGFyYXRlIHByb2JsZW1zIG1lbnRpb25lZCBoZXJl
LiAgVGhlIGZpcnN0IGlzIHRvDQo+ID4gZW5zdXJlIHRoYXQgcmVhZGFoZWFkIChSQSkgcGFnZXMg
YXJlIHRyZWF0ZWQgYXMgbW9yZSBkaXNwb3NhYmxlIHRoYW4NCj4gPiBhY2Nlc3NlZCBwYWdlcyB1
bmRlciBtZW1vcnkgcHJlc3N1cmUgYW5kIHRoZW4gdG8gZGVyaXZlIGEgc3RhdGlzdGljIGZvcg0K
PiA+IGZ1dGlsZSBSQSAodGhvc2UgcGFnZXMgdGhhdCB3ZXJlIHJlYWQgaW4gYnV0IG5ldmVyIGFj
Y2Vzc2VkKS4NCj4gPg0KPiA+IFRoZSBmaXJzdCBzb3VuZHMgcmVhbGx5IGxpa2UgaXRzIGFuIExS
VSB0aGluZyByYXRoZXIgdGhhbiBhZGRpbmcgeWV0DQo+ID4gYW5vdGhlciBwYWdlIGZsYWcuICBX
ZSBuZWVkIGEgcG9zaXRpb24gaW4gdGhlIExSVSBsaXN0IGZvciBuZXZlcg0KPiA+IGFjY2Vzc2Vk
IC4uLiB0aGF0IHdheSB0aGV5J3JlIGZpcnN0IHRvIGJlIGV2aWN0ZWQgYXMgbWVtb3J5IHByZXNz
dXJlDQo+ID4gcmlzZXMuDQo+ID4NCj4gPiBUaGUgc2Vjb25kIGlzIHlvdSBjYW4gZGVyaXZlIHRo
aXMgZnV0aWxlIHJlYWRhaGVhZCBzdGF0aXN0aWMgZnJvbSB0aGUNCj4gPiBMUlUgcG9zaXRpb24g
b2YgdW5hY2Nlc3NlZCBwYWdlcyAuLi4geW91IGNvdWxkIGtlZXAgdGhpcyBnbG9iYWxseS4NCj4g
Pg0KPiA+IE5vdyB0aGUgcHJvYmxlbTogaWYgeW91IHRyYXNoIGFsbCB1bmFjY2Vzc2VkIFJBIHBh
Z2VzIGZpcnN0LCB5b3UgZW5kIHVwDQo+ID4gd2l0aCB0aGUgc2l0dWF0aW9uIG9mIHNheSBwbGF5
aW5nIGEgbW92aWUgdW5kZXIgbW9kZXJhdGUgbWVtb3J5DQo+ID4gcHJlc3N1cmUgdGhhdCB3ZSBk
byBSQSwgdGhlbiB0cmFzaCB0aGUgUkEgcGFnZSB0aGVuIGhhdmUgdG8gcmUtcmVhZCB0byBkaXNw
bGF5DQo+ID4gdG8gdGhlIHVzZXIgcmVzdWx0aW5nIGluIGFuIHVuZGVzaXJhYmxlIHVwdGljayBp
biByZWFkIEkvTy4NCj4gPg0KDQoNCkphbWVzIC0gbm93IHRoYXQgSSdtIHRoaW5raW5nIGFib3V0
IGl0LiBJIHRoaW5rIHRoZSBtb3ZpZSBzaG91bGQgYmUgZmluZSBiZWNhdXNlIHdoZW4gd2UgY2Fs
Y3VsYXRlIHRoZSByZWFkLWhpdCBmcm9tIFJBJ2QgcGFnZXMsIHRoZSBtb3ZpZSBSQSBibG9ja3Mg
d2lsbCBnZXQgYSBnb29kIGhpdC1yYXRpbyBhbmQgaGVuY2UgaXQncyBSQSdkIGJsb2NrcyB3b24n
dCBiZSB0b3VjaGVkLiBCdXQgdGhlbiB3ZSBtaWdodCBuZWVkIHRvIHRyYWNrIHRoZSBoaXQtcmF0
aW8gYXQgdGhlIFJBLWJsb2NrKD8pIGxldmVsLg0KDQpDaGV0YW4NCg0K
