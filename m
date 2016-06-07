From: "Tiezhu Yang" <kernelpatch@126.com>
Subject: Re: [PATCH] scsi: ufs: fix potential memory leak
Date: Wed, 8 Jun 2016 06:49:48 +0800 (CST)
Message-ID: <770e1f6d.59f.1552d0ebd55.Coremail.kernelpatch@126.com>
References: <1a5ff649.111.1552c05f371.Coremail.kernelpatch@126.com>
 <1465326728.2310.39.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1465326728.2310.39.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

QXTCoDIwMTYtMDYtMDjCoDAzOjEyOjA4LMKgIkphbWVzwqBCb3R0b21sZXkiwqA8SmFtZXMuQm90
dG9tbGV5QEhhbnNlblBhcnRuZXJzaGlwLmNvbT7CoHdyb3RlOgo+T27CoFdlZCzCoDIwMTYtMDYt
MDjCoGF0wqAwMjowMMKgKzA4MDAswqBUaWV6aHXCoFlhbmfCoHdyb3RlOgo+PsKgVGhlcmXCoGV4
aXN0c8KgcG90ZW50aWFswqBtZW1vcnnCoGxlYWvCoGluwqB1ZnNoY2RfcGFyc2VfY2xvY2tfaW5m
bygpLAo+PsKgdGhpc8KgcGF0Y2jCoGZpeGVzwqBpdC4KPgo+V2hhdMKgbWFrZXPCoHlvdcKgdGhp
bmvCoHRoZXJlJ3PCoGHCoGxlYWvCoGhlcmU/wqDCoFRoZXNlwqBhcmXCoGFsbMKgZGV2bV8KPmFs
bG9jYXRpb25zLMKgc2/CoHRoZXkncmXCoGFsbMKgZnJlZWTCoHdoZW7CoHRoZcKgZGV2aWNlwqBp
cy7CoMKgSWbCoGFuwqBlcnJvcsKgaXMKPnJldHVybmVkLMKgdGhlwqBkZXZpY2XCoGlzwqByZWxl
YXNlZMKgYW5kwqB0aGXCoG1lbW9yecKgZnJlZWQuCj4KPllvdcKgY2FuwqBhcmd1ZcKgdGhhdMKg
b27CoHN1Y2Nlc3NmdWzCoGluaXRpYWxpemF0aW9uLMKgdGhlcmUnc8Kgbm/CoG5lZWTCoHRvCj5r
ZWVwwqB0aGXCoGNsa2ZyZXHCoGFycmF5wqBidXTCoHRoaXPCoHBhdGNowqBpc24ndMKgdGhlwqB3
YXnCoHlvdSdkwqBjaGFuZ2XCoHRoYXQuCj4KPkphbWVzCj4KT0ssIHRoYW5rcy4gSSB3aWxsIHNl
bmQgYSB2MiBwYXRjaC4=
