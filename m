From: Oliver Neukum <oneukum-IBi9RG/b67k@public.gmane.org>
Subject: Re: JMS56x not working reliably with uas driver
Date: Wed, 21 Dec 2016 15:39:45 +0100
Message-ID: <1482331185.7638.14.camel@suse.com>
References: <585A69E6.6040009@caviumnetworks.com>
         <1482320547.7638.7.camel@suse.com> <585A7073.3060904@caviumnetworks.com>
         <931b00cf-e273-6d07-8a99-71916376af67@redhat.com>
         <585A79F5.7080701@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-ILmmduW1FV6mQ/2VsrB1"
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <585A79F5.7080701-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: George Cherian <gcherian-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
Cc: George.Cherian-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


--=-ILmmduW1FV6mQ/2VsrB1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Wed, 2016-12-21 at 18:17 +0530, George Cherian wrote:
> [  843.149653] scsi host5: uas_post_reset: alloc streams error -19
> after 
> reset

That would mean the endpoints are gone. Which is odd.

> [  843.157268] sd 5:0:0:0: [sdb] Synchronizing SCSI cache

Could you try the attached patch and do a SCSI log of the enumeration?

	Regards
		Oliver


--=-ILmmduW1FV6mQ/2VsrB1
Content-Disposition: attachment; filename="0001-uas-device-crashes-on-reset.patch"
Content-Transfer-Encoding: base64
Content-Type: text/x-patch; name="0001-uas-device-crashes-on-reset.patch";
	charset="UTF-8"

RnJvbSBkNGRkYWM4OGJiZjljYjE1ZTdkODYzODU4MmY5NmQzMWUyNDVmMTViIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBPbGl2ZXIgTmV1a3VtIDxvbmV1a3VtQHN1c2UuY29tPgpEYXRl
OiBXZWQsIDIxIERlYyAyMDE2IDE1OjM0OjU0ICswMTAwClN1YmplY3Q6IFtQQVRDSF0gdWFzOiBk
ZXZpY2UgY3Jhc2hlcyBvbiByZXNldAoKV2UgYXZvaWQgcmVzZXR0aW5nIGl0LgoKU2lnbmVkLW9m
Zi1ieTogT2xpdmVyIE5ldWt1bSA8b25ldWt1bUBzdXNlLmNvbT4KLS0tCiBkcml2ZXJzL3VzYi9j
b3JlL3F1aXJrcy5jIHwgMiArKwogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQoKZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2NvcmUvcXVpcmtzLmMgYi9kcml2ZXJzL3VzYi9jb3JlL3F1
aXJrcy5jCmluZGV4IGQyZTUwYTIuLjUyNDgzZmIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvdXNiL2Nv
cmUvcXVpcmtzLmMKKysrIGIvZHJpdmVycy91c2IvY29yZS9xdWlya3MuYwpAQCAtMTk0LDYgKzE5
NCw4IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgdXNiX2RldmljZV9pZCB1c2JfcXVpcmtfbGlzdFtd
ID0gewogCXsgVVNCX0RFVklDRSgweDE1MzIsIDB4MDExNiksIC5kcml2ZXJfaW5mbyA9CiAJCQlV
U0JfUVVJUktfTElORUFSX1VGUkFNRV9JTlRSX0JJTlRFUlZBTCB9LAogCisJeyBVU0JfREVWSUNF
KDB4MTUyZCwgMHg5NTYxKSwgLmRyaXZlcl9pbmZvID0gVVNCX1FVSVJLX1JFU0VUIH0sCisKIAkv
KiBCVUlMRFdJTiBQaG90byBGcmFtZSAqLwogCXsgVVNCX0RFVklDRSgweDE5MDgsIDB4MTMxNSks
IC5kcml2ZXJfaW5mbyA9CiAJCQlVU0JfUVVJUktfSE9OT1JfQk5VTUlOVEVSRkFDRVMgfSwKLS0g
CjIuMS40Cgo=


--=-ILmmduW1FV6mQ/2VsrB1--

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
