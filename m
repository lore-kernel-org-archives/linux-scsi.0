From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v3 00/26] compat_ioctl: cleanups
Date: Mon, 6 May 2019 12:03:42 +0300
Message-ID: <CAHp75Vc2-zzRYk0vpdPQm5duZwW+v=svEndTPV4Sr59QrGcMHg@mail.gmail.com>
References: <20190416202013.4034148-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20190416202013.4034148-1-arnd@arndb.de>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux NVMe Mailinglist <linux-nvme@lists.infradead.org>, linux-iio <linux-iio@vger.kernel.org>, linux-remoteproc@vger.kernel.org, linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org, Platform Driver <platform-driver-x86@vger.kernel.org>, linux-ide@vger.kernel.org, "open list:MEMORY TECHNOLOGY..." <linux-mtd@lists.infradead.org>, sparclinux@vger.kernel.org, linux1394-devel@lists.sourceforge.net, devel@driverdev.osuosl.org, linux-s390@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-bluetooth@vger.kernel.org, y2038@lists.linaro.org, qat-linux@intel.com, amd-gfx@lists.freedesktop.org, linux-input <linux-input@vger.kernel.org>, Marcel Holtmann <marcel@holtmann.org>, Linux Media Mailing List <linux-media@vger.kernel.org>, "open list:REAL TIME CLOCK (RTC) SUBSYSTEM" <linux-rtc@vger.kernel.org>, ALSA Development Mailing List <alsa-devel@alsa-project.o>
List-Id: linux-scsi@vger.kernel.org

T24gVHVlLCBBcHIgMTYsIDIwMTkgYXQgMTE6MjMgUE0gQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5k
Yi5kZT4gd3JvdGU6Cj4KPiBIaSBBbCwKPgo+IEl0IHRvb2sgbWUgd2F5IGxvbmdlciB0aGFuIEkg
aGFkIGhvcGVkIHRvIHJldmlzaXQgdGhpcyBzZXJpZXMsIHNlZQo+IGh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL2xrbWwvMjAxODA5MTIxNTAxNDIuMTU3OTEzLTEtYXJuZEBhcm5kYi5kZS8KPiBmb3Ig
dGhlIHByZXZpb3VzbHkgcG9zdGVkIHZlcnNpb24uCj4KPiBJJ3ZlIGNvbWUgdG8gdGhlIHBvaW50
IHdoZXJlIGFsbCBjb252ZXJzaW9uIGhhbmRsZXJzIGFuZCBtb3N0Cj4gQ09NUEFUSUJMRV9JT0NU
TCgpIGVudHJpZXMgYXJlIGdvbmUgZnJvbSB0aGlzIGZpbGUsIGJ1dCBmb3IKPiBub3csIHRoaXMg
c2VyaWVzIG9ubHkgaGFzIHRoZSBwYXJ0cyB0aGF0IGhhdmUgZWl0aGVyIGJlZW4gcmV2aWV3ZWQK
PiBwcmV2aW91c2x5LCBvciB0aGF0IGFyZSBzaW1wbGUgZW5vdWdoIHRvIGluY2x1ZGUuCj4KPiBU
aGUgbWFpbiBtaXNzaW5nIHBpZWNlIGlzIHRoZSBTR19JTy9TR19HRVRfUkVRVUVTVF9UQUJMRSBj
b252ZXJzaW9uLgo+IEknbGwgcG9zdCB0aGUgcGF0Y2hlcyBJIG1hZGUgZm9yIHRoYXQgbGF0ZXIs
IGFzIHRoZXkgbmVlZCBtb3JlCj4gdGVzdGluZyBhbmQgcmV2aWV3IGZyb20gdGhlIHNjc2kgbWFp
bnRhaW5lcnMuCj4KPiBJIGhvcGUgeW91IGNhbiBzdGlsbCB0YWtlIHRoZXNlIGZvciB0aGUgY29t
aW5nIG1lcmdlIHdpbmRvdywgdW5sZXNzCj4gbmV3IHByb2JsZW1zIGNvbWUgdXAuCgo+ICBkcml2
ZXJzL3BsYXRmb3JtL3g4Ni93bWkuYyAgICAgICAgICAgICAgICAgIHwgICAyICstCgpBY2tlZC1i
eTogQW5keSBTaGV2Y2hlbmtvIDxhbmR5LnNoZXZjaGVua29AZ21haWwuY29tPgoKLS0gCldpdGgg
QmVzdCBSZWdhcmRzLApBbmR5IFNoZXZjaGVua28KX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlz
dHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4v
bGlzdGluZm8vZHJpLWRldmVs
