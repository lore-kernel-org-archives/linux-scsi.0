From: "Woodhouse, David" <david.woodhouse-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: hpsa driver bug crack kernel down!
Date: Thu, 10 Apr 2014 08:46:28 +0000
Message-ID: <1397119587.19944.14.camel@shinybook.infradead.org>
References: <20140409023935.GE11839@dhcp-16-105.nay.redhat.com>
	<1397083799.2608.20.camel@buesod1.americas.hpqcorp.net>
	<1397084904.9519.62.camel@dabdike> <1397085044.9519.63.camel@dabdike>
	<1397086817.2608.25.camel@buesod1.americas.hpqcorp.net>
	<1397087425.9519.67.camel@dabdike>
	<1397089180.2608.27.camel@buesod1.americas.hpqcorp.net>
	<CAErSpo4H=hcro8sMnt2MzDDVCROpASuUTQWBw37OxodHTyOfyw@mail.gmail.com>
	<1397111557.2608.29.camel@buesod1.americas.hpqcorp.net>
	<20140410071535.GX13491@8bytes.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7643126938001332690=="
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20140410071535.GX13491-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org" <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>
Cc: "bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org" <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "davidlohr-VXdhtT5mjnY@public.gmane.org" <davidlohr-VXdhtT5mjnY@public.gmane.org>, "scameron-3C9H9nn4BS4HL6m8NFMY+dBPR1lH4CV8@public.gmane.org" <scameron-3C9H9nn4BS4HL6m8NFMY+dBPR1lH4CV8@public.gmane.org>, "bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "jiang.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <jiang.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

--===============7643126938001332690==
Content-Language: en-US
Content-Type: multipart/signed; micalg=sha-1;
	protocol="application/x-pkcs7-signature"; boundary="=-Ht/Tf9zBi/x/pm1AbxZe"

--=-Ht/Tf9zBi/x/pm1AbxZe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-04-10 at 09:15 +0200, Joerg Roedel wrote:
> [+ David, VT-d maintainer ]
>=20
> Jiang, David, can you please have a look into this issue?
>=20

> > > >> > > > > DMAR:[fault reason 02] Present bit in context entry is cle=
ar
> > > >> > > > > dmar: DRHD: handling fault status reg 602
> > > >> > > > > dmar: DMAR:[DMA Read] Request device [02:00.0] fault addr =
7f61e000

That "Present bit in context entry is clear" fault means that we have
not set up *any* mappings for this PCI device=E2=80=A6 on this IOMMU.

> > Yes, specifically (finally done bisecting):
> >=20
> > commit 2e45528930388658603ea24d49cf52867b928d3e
> > Author: Jiang Liu <jiang.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > Date:   Wed Feb 19 14:07:36 2014 +0800
> >=20
> >     iommu/vt-d: Unify the way to process DMAR device scope array

This commit is about how we decide which IOMMU a given PCI device is
attached to.

Thus, my first guess would be that we are quite happily setting up the
requested DMA maps on the *wrong* IOMMU, and then taking faults when the
device actually tries to do DMA.

However, I'm not 100% convinced of that. The fault address looks
suspiciously like a true physical address, not a virtual bus address of
the type that we'd normally allocate for a dma_map_* operation. Those
would start at 0xfffff000 and work downwards, typically.

Do you have 'iommu=3Dpt' on the kernel command line? Can I see the full
dmesg as this system boots, and also a copy of the DMAR table?


We should also rate-limit DMA faults, which would avoid the lockup
failure mode. Bjorn, what should an IOMMU driver *do* when it detects
that a device is creating an endless stream of DMA faults and isn't
aborting the transaction?

I can set it to silent so that it just stops *reporting* the DMA faults
for that device... and I suppose I can re-enable them when I next see a
DMA mapping for it (although actually it'd be better to have a hook to
do that on FLR or something like that). But there must be a better
answer than that, surely? And I don't want to hack it up locally in
*one* specific IOMMU driver, any more than I have to.

On a POWER system with EEH, the kernel would end up isolating the
offending device completely, and subsequently resetting it...

--=20
David Woodhouse                            Open Source Technology Centre
David.Woodhouse-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org                              Intel Corporation

--=-Ht/Tf9zBi/x/pm1AbxZe
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

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
kiW8/Nj6KITQvHqz7x/Es0IRJCc9/zBES7yMeD+fgJKHAEv/uTcFfGM9HIWxPQIDAQABo4IC6jCC
AuYwHQYDVR0OBBYEFGK1Mey+kPYGHowHJ0YXtQU4NmbSMB8GA1UdIwQYMBaAFB5pKrTcKP5HGE4h
Cz+8rBEv8Jj1MIHJBgNVHR8EgcEwgb4wgbuggbiggbWGVGh0dHA6Ly93d3cuaW50ZWwuY29tL3Jl
cG9zaXRvcnkvQ1JML0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMElzc3VpbmclMjBDQSUyMDRB
LmNybIZdaHR0cDovL2NlcnRpZmljYXRlcy5pbnRlbC5jb20vcmVwb3NpdG9yeS9DUkwvSW50ZWwl
MjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNzdWluZyUyMENBJTIwNEEuY3JsMIHvBggrBgEFBQcBAQSB
4jCB3zBpBggrBgEFBQcwAoZdaHR0cDovL3d3dy5pbnRlbC5jb20vcmVwb3NpdG9yeS9jZXJ0aWZp
Y2F0ZXMvSW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNzdWluZyUyMENBJTIwNEEuY3J0MHIG
CCsGAQUFBzAChmZodHRwOi8vY2VydGlmaWNhdGVzLmludGVsLmNvbS9yZXBvc2l0b3J5L2NlcnRp
ZmljYXRlcy9JbnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBJc3N1aW5nJTIwQ0ElMjA0QS5jcnQw
CwYDVR0PBAQDAgeAMDwGCSsGAQQBgjcVBwQvMC0GJSsGAQQBgjcVCIbDjHWEmeVRg/2BKIWOn1OC
kcAJZ4HevTmV8EMCAWQCAQgwHwYDVR0lBBgwFgYIKwYBBQUHAwQGCisGAQQBgjcKAwwwKQYJKwYB
BAGCNxUKBBwwGjAKBggrBgEFBQcDBDAMBgorBgEEAYI3CgMMME8GA1UdEQRIMEagKQYKKwYBBAGC
NxQCA6AbDBlkYXZpZC53b29kaG91c2VAaW50ZWwuY29tgRlkYXZpZC53b29kaG91c2VAaW50ZWwu
Y29tMA0GCSqGSIb3DQEBBQUAA4IBAQBCQ4UH3yybC+PzPo7W4PQJQwIDkKfD2i20i/DosQ7+Yeof
KF7qDASe9eoJGXbINBx1u648uOnaMBsxgUUamJo7pdt1ZnsetRtCQrJIsrsJA3Q2MOsrv7xHkzqn
DF99KHEbO2yKvyjJVDznHUWh8M1OFmdoziyWE/VPdqTwXwS/UKO81XaTtWUDGO716HHVlfT9yPle
Ukg2MTcIhhNWmlS8gDUayhteIAlPci71f/oXzXxBiGiO6FVZUEx+rZBQB84Ey0S0Tfm7hiGzoegg
ra0hfiiMOKMio+n0r4NUn03Z+VRUTbdjHIA6Lkozwpadvs9/uK8dIGqfcgxYgk9qdjFPMYICDjCC
AgoCAQEwgYcweTELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAkNBMRQwEgYDVQQHEwtTYW50YSBDbGFy
YTEaMBgGA1UEChMRSW50ZWwgQ29ycG9yYXRpb24xKzApBgNVBAMTIkludGVsIEV4dGVybmFsIEJh
c2ljIElzc3VpbmcgQ0EgNEECCmJiMmoAAAAATKAwCQYFKw4DAhoFAKBdMBgGCSqGSIb3DQEJAzEL
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDQxMDA4NDYyN1owIwYJKoZIhvcNAQkEMRYE
FHk/+SMjSSfDm+Iw5SfE0gK5+wxBMA0GCSqGSIb3DQEBAQUABIIBAL65Uvxl4fEsse8q1cshNFe/
t+oRfnFoEWRBDOxJ4SKcJQ7fU910qBmQSR3NP5r6bUUR16ZjgbrDvR+GtwNWBbjcCeZJSzaW5Rou
u2ESTisQLs2Plft+cjwQmcB97d3TlqDxbrqeVazrkUkdKyay1NBMERBFP6JdAkc6okiHfc99jHLd
sZUboJvuVmN/4Rfxe2pVvpzrnoJX6hMUDxNKqH91bTcyGpWHAzuIuG6Hdx3XT37je9l07wDoLGVF
UIfKOKExdhX6ovtpyMPLcaWXsYiKRezTGjWoiyRa4IIKzTMdPiI6RC33vD4LKukKO/f8oLChwTJt
n7lQ84T452enVEYAAAAAAAA=


--=-Ht/Tf9zBi/x/pm1AbxZe--

--===============7643126938001332690==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7643126938001332690==--
