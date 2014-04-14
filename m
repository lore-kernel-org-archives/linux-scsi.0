From: Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>
Subject: Re: hpsa driver bug crack kernel down!
Date: Mon, 14 Apr 2014 08:45:58 -0700
Message-ID: <1397490358.31076.6.camel@buesod1.americas.hpqcorp.net>
References: <20140409023935.GE11839@dhcp-16-105.nay.redhat.com>
	<1397083799.2608.20.camel@buesod1.americas.hpqcorp.net>
	<1397084904.9519.62.camel@dabdike> <1397085044.9519.63.camel@dabdike>
	<1397086817.2608.25.camel@buesod1.americas.hpqcorp.net>
	<1397087425.9519.67.camel@dabdike>
	<1397089180.2608.27.camel@buesod1.americas.hpqcorp.net>
	<CAErSpo4H=hcro8sMnt2MzDDVCROpASuUTQWBw37OxodHTyOfyw@mail.gmail.com>
	<1397111557.2608.29.camel@buesod1.americas.hpqcorp.net>
	<20140410071535.GX13491@8bytes.org>
	<1397119587.19944.14.camel@shinybook.infradead.org>
	<1397146781.2608.46.camel@buesod1.americas.hpqcorp.net>
	<1397207932.19944.58.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-QUTXniQ2pNUL4SnRpeWD"
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1397207932.19944.58.camel-Fexsq3y4057IgHVZqg5X0TlWvGAXklZc@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Woodhouse, David" <david.woodhouse-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org" <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "scameron-3C9H9nn4BS4HL6m8NFMY+dBPR1lH4CV8@public.gmane.org" <scameron-3C9H9nn4BS4HL6m8NFMY+dBPR1lH4CV8@public.gmane.org>, "bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "jiang.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <jiang.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


--=-QUTXniQ2pNUL4SnRpeWD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Sorry for the delay, I've been having to take turns for this box.

On Fri, 2014-04-11 at 09:18 +0000, Woodhouse, David wrote:
> On Thu, 2014-04-10 at 09:19 -0700, Davidlohr Bueso wrote:
> > Attaching a dmesg from one of the kernels that boots. It doesn't appear
> > to have much of the related information... is there any debug config
> > option I can enable that might give you more data?
> 
> I'd like the contents of /sys/firmware/acpi/tables/DMAR please.

Attached is the disassembly of the raw output.

>  And
> please could you also apply this patch to both the last-working and
> first-failing kernels and show me the output in both cases?

So I still cannot get around getting the info for the first failing
kernel, but below is for the last working. Thanks.

Device 0:03:00.0 on IOMMU at a8000000
Device 0:03:00.0 on IOMMU at a8000000
IOMMU: Setting identity map for device 0000:02:00.0 [0x7f61e000 - 0x7f61ffff]
Device 0:02:00.0 on IOMMU at a8000000
Device 0:02:00.0 on IOMMU at a8000000
IOMMU: Setting identity map for device 0000:02:00.2 [0x7f61e000 - 0x7f61ffff]
Device 0:02:00.2 on IOMMU at a8000000
Device 0:02:00.2 on IOMMU at a8000000
IOMMU: Setting identity map for device 0000:00:1d.0 [0x7f7e7000 - 0x7f7ecfff]
Device 0:00:1d.0 on IOMMU at a8000000
Device 0:00:1d.0 on IOMMU at a8000000
IOMMU: Setting identity map for device 0000:00:1d.1 [0x7f7e7000 - 0x7f7ecfff]
Device 0:00:1d.1 on IOMMU at a8000000
Device 0:00:1d.1 on IOMMU at a8000000
IOMMU: Setting identity map for device 0000:00:1d.2 [0x7f7e7000 - 0x7f7ecfff]
Device 0:00:1d.2 on IOMMU at a8000000
Device 0:00:1d.2 on IOMMU at a8000000
IOMMU: Setting identity map for device 0000:00:1d.3 [0x7f7e7000 - 0x7f7ecfff]
Device 0:00:1d.3 on IOMMU at a8000000
Device 0:00:1d.3 on IOMMU at a8000000
IOMMU: Setting identity map for device 0000:02:00.0 [0x7f7e7000 - 0x7f7ecfff]
Device 0:02:00.0 on IOMMU at a8000000
IOMMU: Setting identity map for device 0000:02:00.2 [0x7f7e7000 - 0x7f7ecfff]
Device 0:02:00.2 on IOMMU at a8000000
IOMMU: Setting identity map for device 0000:02:00.4 [0x7f7e7000 - 0x7f7ecfff]
Device 0:02:00.4 on IOMMU at a8000000
Device 0:02:00.4 on IOMMU at a8000000
IOMMU: Setting identity map for device 0000:00:1d.7 [0x7f7ee000 - 0x7f7effff]
Device 0:00:1d.7 on IOMMU at a8000000
Device 0:00:1d.7 on IOMMU at a8000000
IOMMU: Prepare 0-16MiB unity mapping for LPC
IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
Device 0:00:1f.0 on IOMMU at a8000000
Device 0:00:1f.0 on IOMMU at a8000000
PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
Device 0:00:00.0 on IOMMU at a8000000
Device 0:00:01.0 on IOMMU at a8000000
Device 0:00:02.0 on IOMMU at a8000000
Device 0:00:03.0 on IOMMU at a8000000
Device 0:00:04.0 on IOMMU at a8000000
Device 0:00:05.0 on IOMMU at a8000000
Device 0:00:06.0 on IOMMU at a8000000
Device 0:00:07.0 on IOMMU at a8000000
Device 0:00:08.0 on IOMMU at a8000000
Device 0:00:09.0 on IOMMU at a8000000
Device 0:00:0a.0 on IOMMU at a8000000
Device 0:00:14.0 on IOMMU at a8000000
Device 0:00:1c.0 on IOMMU at a8000000
Device 0:00:1c.4 on IOMMU at a8000000
Device 0:00:1d.0 on IOMMU at a8000000
Device 0:00:1d.1 on IOMMU at a8000000
Device 0:00:1d.2 on IOMMU at a8000000
Device 0:00:1d.3 on IOMMU at a8000000
Device 0:00:1d.7 on IOMMU at a8000000
Device 0:00:1e.0 on IOMMU at a8000000
Device 0:00:1f.0 on IOMMU at a8000000
Device 0:04:00.0 on IOMMU at a8000000
Device 0:04:00.1 on IOMMU at a8000000
Device 0:04:00.2 on IOMMU at a8000000
Device 0:04:00.3 on IOMMU at a8000000
Device 0:03:00.0 on IOMMU at a8000000
Device 0:02:00.0 on IOMMU at a8000000
Device 0:02:00.2 on IOMMU at a8000000
Device 0:02:00.4 on IOMMU at a8000000
Device 0:01:03.0 on IOMMU at a8000000
Device 0:50:00.0 on IOMMU at ac000000
Device 0:50:01.0 on IOMMU at ac000000
Device 0:50:02.0 on IOMMU at ac000000
Device 0:50:03.0 on IOMMU at ac000000
Device 0:50:04.0 on IOMMU at ac000000
Device 0:50:05.0 on IOMMU at ac000000
Device 0:50:06.0 on IOMMU at ac000000
Device 0:50:07.0 on IOMMU at ac000000
Device 0:50:08.0 on IOMMU at ac000000
Device 0:50:09.0 on IOMMU at ac000000
Device 0:50:0a.0 on IOMMU at ac000000
Device 0:50:14.0 on IOMMU at a8000000
Device 0:a0:00.0 on IOMMU at b0000000
Device 0:a0:01.0 on IOMMU at b0000000
Device 0:a0:02.0 on IOMMU at b0000000
Device 0:a0:03.0 on IOMMU at b0000000
Device 0:a0:04.0 on IOMMU at b0000000
Device 0:a0:05.0 on IOMMU at b0000000
Device 0:a0:06.0 on IOMMU at b0000000
Device 0:a0:07.0 on IOMMU at b0000000
Device 0:a0:08.0 on IOMMU at b0000000
Device 0:a0:09.0 on IOMMU at b0000000
Device 0:a0:0a.0 on IOMMU at b0000000
Device 0:a0:14.0 on IOMMU at a8000000
Device 0:7c:00.0 on IOMMU at a8000000
Device 0:7c:08.0 on IOMMU at a8000000
Device 0:82:00.0 on IOMMU at a8000000
Device 0:82:08.0 on IOMMU at a8000000


--=-QUTXniQ2pNUL4SnRpeWD
Content-Disposition: attachment; filename="DMAR.dsl"
Content-Type: text/x-dsl; name="DMAR.dsl"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

/*
 * Intel ACPI Component Architecture
 * AML Disassembler version 20140325-64 [Apr 11 2014]
 * Copyright (c) 2000 - 2014 Intel Corporation
 * 
 * Disassembly of DMAR.raw, Fri Apr 11 09:10:10 2014
 *
 * ACPI Data Table [DMAR]
 *
 * Format: [HexOffset DecimalOffset ByteLength]  FieldName : FieldValue
 */

[000h 0000   4]                    Signature : "DMAR"    [DMA Remapping table]
[004h 0004   4]                 Table Length : 000002F4
[008h 0008   1]                     Revision : 01
[009h 0009   1]                     Checksum : AB
[00Ah 0010   6]                       Oem ID : "HP    "
[010h 0016   8]                 Oem Table ID : "ProLiant"
[018h 0024   4]                 Oem Revision : 00000001
[01Ch 0028   4]              Asl Compiler ID : "  "
[020h 0032   4]        Asl Compiler Revision : 0000162E

[024h 0036   1]           Host Address Width : 2B
[025h 0037   1]                        Flags : 01
[026h 0038  10]                     Reserved : 00 00 00 00 00 00 00 00 00 00

[030h 0048   2]                Subtable Type : 0000 [Hardware Unit Definition]
[032h 0050   2]                       Length : 0070

[034h 0052   1]                        Flags : 00
[035h 0053   1]                     Reserved : 00
[036h 0054   2]           PCI Segment Number : 0000
[038h 0056   8]        Register Base Address : 00000000B0000000

[040h 0064   1]      Device Scope Entry Type : 02
[041h 0065   1]                 Entry Length : 08
[042h 0066   2]                     Reserved : 0000
[044h 0068   1]               Enumeration ID : 00
[045h 0069   1]               PCI Bus Number : A0

[046h 0070   2]                     PCI Path : 0A,00


[048h 0072   1]      Device Scope Entry Type : 02
[049h 0073   1]                 Entry Length : 08
[04Ah 0074   2]                     Reserved : 0000
[04Ch 0076   1]               Enumeration ID : 00
[04Dh 0077   1]               PCI Bus Number : A0

[04Eh 0078   2]                     PCI Path : 09,00


[050h 0080   1]      Device Scope Entry Type : 02
[051h 0081   1]                 Entry Length : 08
[052h 0082   2]                     Reserved : 0000
[054h 0084   1]               Enumeration ID : 00
[055h 0085   1]               PCI Bus Number : A0

[056h 0086   2]                     PCI Path : 08,00


[058h 0088   1]      Device Scope Entry Type : 02
[059h 0089   1]                 Entry Length : 08
[05Ah 0090   2]                     Reserved : 0000
[05Ch 0092   1]               Enumeration ID : 00
[05Dh 0093   1]               PCI Bus Number : A0

[05Eh 0094   2]                     PCI Path : 07,00


[060h 0096   1]      Device Scope Entry Type : 02
[061h 0097   1]                 Entry Length : 08
[062h 0098   2]                     Reserved : 0000
[064h 0100   1]               Enumeration ID : 00
[065h 0101   1]               PCI Bus Number : A0

[066h 0102   2]                     PCI Path : 06,00


[068h 0104   1]      Device Scope Entry Type : 02
[069h 0105   1]                 Entry Length : 08
[06Ah 0106   2]                     Reserved : 0000
[06Ch 0108   1]               Enumeration ID : 00
[06Dh 0109   1]               PCI Bus Number : A0

[06Eh 0110   2]                     PCI Path : 05,00


[070h 0112   1]      Device Scope Entry Type : 02
[071h 0113   1]                 Entry Length : 08
[072h 0114   2]                     Reserved : 0000
[074h 0116   1]               Enumeration ID : 00
[075h 0117   1]               PCI Bus Number : A0

[076h 0118   2]                     PCI Path : 04,00


[078h 0120   1]      Device Scope Entry Type : 02
[079h 0121   1]                 Entry Length : 08
[07Ah 0122   2]                     Reserved : 0000
[07Ch 0124   1]               Enumeration ID : 00
[07Dh 0125   1]               PCI Bus Number : A0

[07Eh 0126   2]                     PCI Path : 03,00


[080h 0128   1]      Device Scope Entry Type : 02
[081h 0129   1]                 Entry Length : 08
[082h 0130   2]                     Reserved : 0000
[084h 0132   1]               Enumeration ID : 00
[085h 0133   1]               PCI Bus Number : A0

[086h 0134   2]                     PCI Path : 02,00


[088h 0136   1]      Device Scope Entry Type : 02
[089h 0137   1]                 Entry Length : 08
[08Ah 0138   2]                     Reserved : 0000
[08Ch 0140   1]               Enumeration ID : 00
[08Dh 0141   1]               PCI Bus Number : A0

[08Eh 0142   2]                     PCI Path : 01,00


[090h 0144   1]      Device Scope Entry Type : 02
[091h 0145   1]                 Entry Length : 08
[092h 0146   2]                     Reserved : 0000
[094h 0148   1]               Enumeration ID : 00
[095h 0149   1]               PCI Bus Number : A0

[096h 0150   2]                     PCI Path : 00,00


[098h 0152   1]      Device Scope Entry Type : 03
[099h 0153   1]                 Entry Length : 08
[09Ah 0154   2]                     Reserved : 0000
[09Ch 0156   1]               Enumeration ID : 0C
[09Dh 0157   1]               PCI Bus Number : A0

[09Eh 0158   2]                     PCI Path : 13,00


[0A0h 0160   2]                Subtable Type : 0000 [Hardware Unit Definition]
[0A2h 0162   2]                       Length : 0070

[0A4h 0164   1]                        Flags : 00
[0A5h 0165   1]                     Reserved : 00
[0A6h 0166   2]           PCI Segment Number : 0000
[0A8h 0168   8]        Register Base Address : 00000000AC000000

[0B0h 0176   1]      Device Scope Entry Type : 02
[0B1h 0177   1]                 Entry Length : 08
[0B2h 0178   2]                     Reserved : 0000
[0B4h 0180   1]               Enumeration ID : 00
[0B5h 0181   1]               PCI Bus Number : 50

[0B6h 0182   2]                     PCI Path : 0A,00


[0B8h 0184   1]      Device Scope Entry Type : 02
[0B9h 0185   1]                 Entry Length : 08
[0BAh 0186   2]                     Reserved : 0000
[0BCh 0188   1]               Enumeration ID : 00
[0BDh 0189   1]               PCI Bus Number : 50

[0BEh 0190   2]                     PCI Path : 09,00


[0C0h 0192   1]      Device Scope Entry Type : 02
[0C1h 0193   1]                 Entry Length : 08
[0C2h 0194   2]                     Reserved : 0000
[0C4h 0196   1]               Enumeration ID : 00
[0C5h 0197   1]               PCI Bus Number : 50

[0C6h 0198   2]                     PCI Path : 08,00


[0C8h 0200   1]      Device Scope Entry Type : 02
[0C9h 0201   1]                 Entry Length : 08
[0CAh 0202   2]                     Reserved : 0000
[0CCh 0204   1]               Enumeration ID : 00
[0CDh 0205   1]               PCI Bus Number : 50

[0CEh 0206   2]                     PCI Path : 07,00


[0D0h 0208   1]      Device Scope Entry Type : 02
[0D1h 0209   1]                 Entry Length : 08
[0D2h 0210   2]                     Reserved : 0000
[0D4h 0212   1]               Enumeration ID : 00
[0D5h 0213   1]               PCI Bus Number : 50

[0D6h 0214   2]                     PCI Path : 06,00


[0D8h 0216   1]      Device Scope Entry Type : 02
[0D9h 0217   1]                 Entry Length : 08
[0DAh 0218   2]                     Reserved : 0000
[0DCh 0220   1]               Enumeration ID : 00
[0DDh 0221   1]               PCI Bus Number : 50

[0DEh 0222   2]                     PCI Path : 05,00


[0E0h 0224   1]      Device Scope Entry Type : 02
[0E1h 0225   1]                 Entry Length : 08
[0E2h 0226   2]                     Reserved : 0000
[0E4h 0228   1]               Enumeration ID : 00
[0E5h 0229   1]               PCI Bus Number : 50

[0E6h 0230   2]                     PCI Path : 04,00


[0E8h 0232   1]      Device Scope Entry Type : 02
[0E9h 0233   1]                 Entry Length : 08
[0EAh 0234   2]                     Reserved : 0000
[0ECh 0236   1]               Enumeration ID : 00
[0EDh 0237   1]               PCI Bus Number : 50

[0EEh 0238   2]                     PCI Path : 03,00


[0F0h 0240   1]      Device Scope Entry Type : 02
[0F1h 0241   1]                 Entry Length : 08
[0F2h 0242   2]                     Reserved : 0000
[0F4h 0244   1]               Enumeration ID : 00
[0F5h 0245   1]               PCI Bus Number : 50

[0F6h 0246   2]                     PCI Path : 02,00


[0F8h 0248   1]      Device Scope Entry Type : 02
[0F9h 0249   1]                 Entry Length : 08
[0FAh 0250   2]                     Reserved : 0000
[0FCh 0252   1]               Enumeration ID : 00
[0FDh 0253   1]               PCI Bus Number : 50

[0FEh 0254   2]                     PCI Path : 01,00


[100h 0256   1]      Device Scope Entry Type : 02
[101h 0257   1]                 Entry Length : 08
[102h 0258   2]                     Reserved : 0000
[104h 0260   1]               Enumeration ID : 00
[105h 0261   1]               PCI Bus Number : 50

[106h 0262   2]                     PCI Path : 00,00


[108h 0264   1]      Device Scope Entry Type : 03
[109h 0265   1]                 Entry Length : 08
[10Ah 0266   2]                     Reserved : 0000
[10Ch 0268   1]               Enumeration ID : 0A
[10Dh 0269   1]               PCI Bus Number : 50

[10Eh 0270   2]                     PCI Path : 13,00


[110h 0272   2]                Subtable Type : 0000 [Hardware Unit Definition]
[112h 0274   2]                       Length : 0020

[114h 0276   1]                        Flags : 01
[115h 0277   1]                     Reserved : 00
[116h 0278   2]           PCI Segment Number : 0000
[118h 0280   8]        Register Base Address : 00000000A8000000

[120h 0288   1]      Device Scope Entry Type : 03
[121h 0289   1]                 Entry Length : 08
[122h 0290   2]                     Reserved : 0000
[124h 0292   1]               Enumeration ID : 08
[125h 0293   1]               PCI Bus Number : 00

[126h 0294   2]                     PCI Path : 1E,01


[128h 0296   1]      Device Scope Entry Type : 03
[129h 0297   1]                 Entry Length : 08
[12Ah 0298   2]                     Reserved : 0000
[12Ch 0300   1]               Enumeration ID : 00
[12Dh 0301   1]               PCI Bus Number : 00

[12Eh 0302   2]                     PCI Path : 13,00


[130h 0304   2]                Subtable Type : 0001 [Reserved Memory Region]
[132h 0306   2]                       Length : 0020

[134h 0308   2]                     Reserved : 0000
[136h 0310   2]           PCI Segment Number : 0000
[138h 0312   8]                 Base Address : 000000007F7EE000
[140h 0320   8]          End Address (limit) : 000000007F7EFFFF

[148h 0328   1]      Device Scope Entry Type : 01
[149h 0329   1]                 Entry Length : 08
[14Ah 0330   2]                     Reserved : 0000
[14Ch 0332   1]               Enumeration ID : 00
[14Dh 0333   1]               PCI Bus Number : 00

[14Eh 0334   2]                     PCI Path : 1D,07


[150h 0336   2]                Subtable Type : 0001 [Reserved Memory Region]
[152h 0338   2]                       Length : 0056

[154h 0340   2]                     Reserved : 0000
[156h 0342   2]           PCI Segment Number : 0000
[158h 0344   8]                 Base Address : 000000007F7E7000
[160h 0352   8]          End Address (limit) : 000000007F7ECFFF

[168h 0360   1]      Device Scope Entry Type : 01
[169h 0361   1]                 Entry Length : 08
[16Ah 0362   2]                     Reserved : 0000
[16Ch 0364   1]               Enumeration ID : 00
[16Dh 0365   1]               PCI Bus Number : 00

[16Eh 0366   2]                     PCI Path : 1D,00


[170h 0368   1]      Device Scope Entry Type : 01
[171h 0369   1]                 Entry Length : 08
[172h 0370   2]                     Reserved : 0000
[174h 0372   1]               Enumeration ID : 00
[175h 0373   1]               PCI Bus Number : 00

[176h 0374   2]                     PCI Path : 1D,01


[178h 0376   1]      Device Scope Entry Type : 01
[179h 0377   1]                 Entry Length : 08
[17Ah 0378   2]                     Reserved : 0000
[17Ch 0380   1]               Enumeration ID : 00
[17Dh 0381   1]               PCI Bus Number : 00

[17Eh 0382   2]                     PCI Path : 1D,02


[180h 0384   1]      Device Scope Entry Type : 01
[181h 0385   1]                 Entry Length : 08
[182h 0386   2]                     Reserved : 0000
[184h 0388   1]               Enumeration ID : 00
[185h 0389   1]               PCI Bus Number : 00

[186h 0390   2]                     PCI Path : 1D,03


[188h 0392   1]      Device Scope Entry Type : 01
[189h 0393   1]                 Entry Length : 0A
[18Ah 0394   2]                     Reserved : 0000
[18Ch 0396   1]               Enumeration ID : 00
[18Dh 0397   1]               PCI Bus Number : 00

[18Eh 0398   2]                     PCI Path : 1C,04

[190h 0400   2]                     PCI Path : 00,00


[192h 0402   1]      Device Scope Entry Type : 01
[193h 0403   1]                 Entry Length : 0A
[194h 0404   2]                     Reserved : 0000
[196h 0406   1]               Enumeration ID : 00
[197h 0407   1]               PCI Bus Number : 00

[198h 0408   2]                     PCI Path : 1C,04

[19Ah 0410   2]                     PCI Path : 00,02


[19Ch 0412   1]      Device Scope Entry Type : 01
[19Dh 0413   1]                 Entry Length : 0A
[19Eh 0414   2]                     Reserved : 0000
[1A0h 0416   1]               Enumeration ID : 00
[1A1h 0417   1]               PCI Bus Number : 00

[1A2h 0418   2]                     PCI Path : 1C,04

[1A4h 0420   2]                     PCI Path : 00,04


[1A6h 0422   2]                Subtable Type : 0001 [Reserved Memory Region]
[1A8h 0424   2]                       Length : 0036

[1AAh 0426   2]                     Reserved : 0000
[1ACh 0428   2]           PCI Segment Number : 0000
[1AEh 0430   8]                 Base Address : 000000007F61E000
[1B6h 0438   8]          End Address (limit) : 000000007F61FFFF

[1BEh 0446   1]      Device Scope Entry Type : 01
[1BFh 0447   1]                 Entry Length : 0A
[1C0h 0448   2]                     Reserved : 0000
[1C2h 0450   1]               Enumeration ID : 00
[1C3h 0451   1]               PCI Bus Number : 00

[1C4h 0452   2]                     PCI Path : 1C,00

[1C6h 0454   2]                     PCI Path : 00,00


[1C8h 0456   1]      Device Scope Entry Type : 01
[1C9h 0457   1]                 Entry Length : 0A
[1CAh 0458   2]                     Reserved : 0000
[1CCh 0460   1]               Enumeration ID : 00
[1CDh 0461   1]               PCI Bus Number : 00

[1CEh 0462   2]                     PCI Path : 1C,04

[1D0h 0464   2]                     PCI Path : 00,00


[1D2h 0466   1]      Device Scope Entry Type : 01
[1D3h 0467   1]                 Entry Length : 0A
[1D4h 0468   2]                     Reserved : 0000
[1D6h 0470   1]               Enumeration ID : 00
[1D7h 0471   1]               PCI Bus Number : 00

[1D8h 0472   2]                     PCI Path : 1C,04

[1DAh 0474   2]                     PCI Path : 00,02


[1DCh 0476   2]                Subtable Type : 0002 [Root Port ATS Capability]
[1DEh 0478   2]                       Length : 0060

[1E0h 0480   1]                        Flags : 00
[1E1h 0481   1]                     Reserved : 00
[1E2h 0482   2]           PCI Segment Number : 0000

[1E4h 0484   1]      Device Scope Entry Type : 02
[1E5h 0485   1]                 Entry Length : 08
[1E6h 0486   2]                     Reserved : 0000
[1E8h 0488   1]               Enumeration ID : 00
[1E9h 0489   1]               PCI Bus Number : A0

[1EAh 0490   2]                     PCI Path : 0A,00


[1ECh 0492   1]      Device Scope Entry Type : 02
[1EDh 0493   1]                 Entry Length : 08
[1EEh 0494   2]                     Reserved : 0000
[1F0h 0496   1]               Enumeration ID : 00
[1F1h 0497   1]               PCI Bus Number : A0

[1F2h 0498   2]                     PCI Path : 09,00


[1F4h 0500   1]      Device Scope Entry Type : 02
[1F5h 0501   1]                 Entry Length : 08
[1F6h 0502   2]                     Reserved : 0000
[1F8h 0504   1]               Enumeration ID : 00
[1F9h 0505   1]               PCI Bus Number : A0

[1FAh 0506   2]                     PCI Path : 08,00


[1FCh 0508   1]      Device Scope Entry Type : 02
[1FDh 0509   1]                 Entry Length : 08
[1FEh 0510   2]                     Reserved : 0000
[200h 0512   1]               Enumeration ID : 00
[201h 0513   1]               PCI Bus Number : A0

[202h 0514   2]                     PCI Path : 07,00


[204h 0516   1]      Device Scope Entry Type : 02
[205h 0517   1]                 Entry Length : 08
[206h 0518   2]                     Reserved : 0000
[208h 0520   1]               Enumeration ID : 00
[209h 0521   1]               PCI Bus Number : A0

[20Ah 0522   2]                     PCI Path : 06,00


[20Ch 0524   1]      Device Scope Entry Type : 02
[20Dh 0525   1]                 Entry Length : 08
[20Eh 0526   2]                     Reserved : 0000
[210h 0528   1]               Enumeration ID : 00
[211h 0529   1]               PCI Bus Number : A0

[212h 0530   2]                     PCI Path : 05,00


[214h 0532   1]      Device Scope Entry Type : 02
[215h 0533   1]                 Entry Length : 08
[216h 0534   2]                     Reserved : 0000
[218h 0536   1]               Enumeration ID : 00
[219h 0537   1]               PCI Bus Number : A0

[21Ah 0538   2]                     PCI Path : 04,00


[21Ch 0540   1]      Device Scope Entry Type : 02
[21Dh 0541   1]                 Entry Length : 08
[21Eh 0542   2]                     Reserved : 0000
[220h 0544   1]               Enumeration ID : 00
[221h 0545   1]               PCI Bus Number : A0

[222h 0546   2]                     PCI Path : 03,00


[224h 0548   1]      Device Scope Entry Type : 02
[225h 0549   1]                 Entry Length : 08
[226h 0550   2]                     Reserved : 0000
[228h 0552   1]               Enumeration ID : 00
[229h 0553   1]               PCI Bus Number : A0

[22Ah 0554   2]                     PCI Path : 02,00


[22Ch 0556   1]      Device Scope Entry Type : 02
[22Dh 0557   1]                 Entry Length : 08
[22Eh 0558   2]                     Reserved : 0000
[230h 0560   1]               Enumeration ID : 00
[231h 0561   1]               PCI Bus Number : A0

[232h 0562   2]                     PCI Path : 01,00


[234h 0564   1]      Device Scope Entry Type : 02
[235h 0565   1]                 Entry Length : 08
[236h 0566   2]                     Reserved : 0000
[238h 0568   1]               Enumeration ID : 00
[239h 0569   1]               PCI Bus Number : A0

[23Ah 0570   2]                     PCI Path : 00,00


[23Ch 0572   2]                Subtable Type : 0002 [Root Port ATS Capability]
[23Eh 0574   2]                       Length : 0060

[240h 0576   1]                        Flags : 00
[241h 0577   1]                     Reserved : 00
[242h 0578   2]           PCI Segment Number : 0000

[244h 0580   1]      Device Scope Entry Type : 02
[245h 0581   1]                 Entry Length : 08
[246h 0582   2]                     Reserved : 0000
[248h 0584   1]               Enumeration ID : 00
[249h 0585   1]               PCI Bus Number : 50

[24Ah 0586   2]                     PCI Path : 0A,00


[24Ch 0588   1]      Device Scope Entry Type : 02
[24Dh 0589   1]                 Entry Length : 08
[24Eh 0590   2]                     Reserved : 0000
[250h 0592   1]               Enumeration ID : 00
[251h 0593   1]               PCI Bus Number : 50

[252h 0594   2]                     PCI Path : 09,00


[254h 0596   1]      Device Scope Entry Type : 02
[255h 0597   1]                 Entry Length : 08
[256h 0598   2]                     Reserved : 0000
[258h 0600   1]               Enumeration ID : 00
[259h 0601   1]               PCI Bus Number : 50

[25Ah 0602   2]                     PCI Path : 08,00


[25Ch 0604   1]      Device Scope Entry Type : 02
[25Dh 0605   1]                 Entry Length : 08
[25Eh 0606   2]                     Reserved : 0000
[260h 0608   1]               Enumeration ID : 00
[261h 0609   1]               PCI Bus Number : 50

[262h 0610   2]                     PCI Path : 07,00


[264h 0612   1]      Device Scope Entry Type : 02
[265h 0613   1]                 Entry Length : 08
[266h 0614   2]                     Reserved : 0000
[268h 0616   1]               Enumeration ID : 00
[269h 0617   1]               PCI Bus Number : 50

[26Ah 0618   2]                     PCI Path : 06,00


[26Ch 0620   1]      Device Scope Entry Type : 02
[26Dh 0621   1]                 Entry Length : 08
[26Eh 0622   2]                     Reserved : 0000
[270h 0624   1]               Enumeration ID : 00
[271h 0625   1]               PCI Bus Number : 50

[272h 0626   2]                     PCI Path : 05,00


[274h 0628   1]      Device Scope Entry Type : 02
[275h 0629   1]                 Entry Length : 08
[276h 0630   2]                     Reserved : 0000
[278h 0632   1]               Enumeration ID : 00
[279h 0633   1]               PCI Bus Number : 50

[27Ah 0634   2]                     PCI Path : 04,00


[27Ch 0636   1]      Device Scope Entry Type : 02
[27Dh 0637   1]                 Entry Length : 08
[27Eh 0638   2]                     Reserved : 0000
[280h 0640   1]               Enumeration ID : 00
[281h 0641   1]               PCI Bus Number : 50

[282h 0642   2]                     PCI Path : 03,00


[284h 0644   1]      Device Scope Entry Type : 02
[285h 0645   1]                 Entry Length : 08
[286h 0646   2]                     Reserved : 0000
[288h 0648   1]               Enumeration ID : 00
[289h 0649   1]               PCI Bus Number : 50

[28Ah 0650   2]                     PCI Path : 02,00


[28Ch 0652   1]      Device Scope Entry Type : 02
[28Dh 0653   1]                 Entry Length : 08
[28Eh 0654   2]                     Reserved : 0000
[290h 0656   1]               Enumeration ID : 00
[291h 0657   1]               PCI Bus Number : 50

[292h 0658   2]                     PCI Path : 01,00


[294h 0660   1]      Device Scope Entry Type : 02
[295h 0661   1]                 Entry Length : 08
[296h 0662   2]                     Reserved : 0000
[298h 0664   1]               Enumeration ID : 00
[299h 0665   1]               PCI Bus Number : 50

[29Ah 0666   2]                     PCI Path : 00,00


[29Ch 0668   2]                Subtable Type : 0002 [Root Port ATS Capability]
[29Eh 0670   2]                       Length : 0058

[2A0h 0672   1]                        Flags : 00
[2A1h 0673   1]                     Reserved : 00
[2A2h 0674   2]           PCI Segment Number : 0000

[2A4h 0676   1]      Device Scope Entry Type : 02
[2A5h 0677   1]                 Entry Length : 08
[2A6h 0678   2]                     Reserved : 0000
[2A8h 0680   1]               Enumeration ID : 00
[2A9h 0681   1]               PCI Bus Number : 00

[2AAh 0682   2]                     PCI Path : 0A,00


[2ACh 0684   1]      Device Scope Entry Type : 02
[2ADh 0685   1]                 Entry Length : 08
[2AEh 0686   2]                     Reserved : 0000
[2B0h 0688   1]               Enumeration ID : 00
[2B1h 0689   1]               PCI Bus Number : 00

[2B2h 0690   2]                     PCI Path : 09,00


[2B4h 0692   1]      Device Scope Entry Type : 02
[2B5h 0693   1]                 Entry Length : 08
[2B6h 0694   2]                     Reserved : 0000
[2B8h 0696   1]               Enumeration ID : 00
[2B9h 0697   1]               PCI Bus Number : 00

[2BAh 0698   2]                     PCI Path : 08,00


[2BCh 0700   1]      Device Scope Entry Type : 02
[2BDh 0701   1]                 Entry Length : 08
[2BEh 0702   2]                     Reserved : 0000
[2C0h 0704   1]               Enumeration ID : 00
[2C1h 0705   1]               PCI Bus Number : 00

[2C2h 0706   2]                     PCI Path : 07,00


[2C4h 0708   1]      Device Scope Entry Type : 02
[2C5h 0709   1]                 Entry Length : 08
[2C6h 0710   2]                     Reserved : 0000
[2C8h 0712   1]               Enumeration ID : 00
[2C9h 0713   1]               PCI Bus Number : 00

[2CAh 0714   2]                     PCI Path : 06,00


[2CCh 0716   1]      Device Scope Entry Type : 02
[2CDh 0717   1]                 Entry Length : 08
[2CEh 0718   2]                     Reserved : 0000
[2D0h 0720   1]               Enumeration ID : 00
[2D1h 0721   1]               PCI Bus Number : 00

[2D2h 0722   2]                     PCI Path : 05,00


[2D4h 0724   1]      Device Scope Entry Type : 02
[2D5h 0725   1]                 Entry Length : 08
[2D6h 0726   2]                     Reserved : 0000
[2D8h 0728   1]               Enumeration ID : 00
[2D9h 0729   1]               PCI Bus Number : 00

[2DAh 0730   2]                     PCI Path : 04,00


[2DCh 0732   1]      Device Scope Entry Type : 02
[2DDh 0733   1]                 Entry Length : 08
[2DEh 0734   2]                     Reserved : 0000
[2E0h 0736   1]               Enumeration ID : 00
[2E1h 0737   1]               PCI Bus Number : 00

[2E2h 0738   2]                     PCI Path : 03,00


[2E4h 0740   1]      Device Scope Entry Type : 02
[2E5h 0741   1]                 Entry Length : 08
[2E6h 0742   2]                     Reserved : 0000
[2E8h 0744   1]               Enumeration ID : 00
[2E9h 0745   1]               PCI Bus Number : 00

[2EAh 0746   2]                     PCI Path : 02,00


[2ECh 0748   1]      Device Scope Entry Type : 02
[2EDh 0749   1]                 Entry Length : 08
[2EEh 0750   2]                     Reserved : 0000
[2F0h 0752   1]               Enumeration ID : 00
[2F1h 0753   1]               PCI Bus Number : 00

[2F2h 0754   2]                     PCI Path : 01,00


Raw Table Data: Length 756 (0x2F4)

  0000: 44 4D 41 52 F4 02 00 00 01 AB 48 50 20 20 20 20  DMAR......HP    
  0010: 50 72 6F 4C 69 61 6E 74 01 00 00 00 D2 04 00 00  ProLiant........
  0020: 2E 16 00 00 2B 01 00 00 00 00 00 00 00 00 00 00  ....+...........
  0030: 00 00 70 00 00 00 00 00 00 00 00 B0 00 00 00 00  ..p.............
  0040: 02 08 00 00 00 A0 0A 00 02 08 00 00 00 A0 09 00  ................
  0050: 02 08 00 00 00 A0 08 00 02 08 00 00 00 A0 07 00  ................
  0060: 02 08 00 00 00 A0 06 00 02 08 00 00 00 A0 05 00  ................
  0070: 02 08 00 00 00 A0 04 00 02 08 00 00 00 A0 03 00  ................
  0080: 02 08 00 00 00 A0 02 00 02 08 00 00 00 A0 01 00  ................
  0090: 02 08 00 00 00 A0 00 00 03 08 00 00 0C A0 13 00  ................
  00A0: 00 00 70 00 00 00 00 00 00 00 00 AC 00 00 00 00  ..p.............
  00B0: 02 08 00 00 00 50 0A 00 02 08 00 00 00 50 09 00  .....P.......P..
  00C0: 02 08 00 00 00 50 08 00 02 08 00 00 00 50 07 00  .....P.......P..
  00D0: 02 08 00 00 00 50 06 00 02 08 00 00 00 50 05 00  .....P.......P..
  00E0: 02 08 00 00 00 50 04 00 02 08 00 00 00 50 03 00  .....P.......P..
  00F0: 02 08 00 00 00 50 02 00 02 08 00 00 00 50 01 00  .....P.......P..
  0100: 02 08 00 00 00 50 00 00 03 08 00 00 0A 50 13 00  .....P.......P..
  0110: 00 00 20 00 01 00 00 00 00 00 00 A8 00 00 00 00  .. .............
  0120: 03 08 00 00 08 00 1E 01 03 08 00 00 00 00 13 00  ................
  0130: 01 00 20 00 00 00 00 00 00 E0 7E 7F 00 00 00 00  .. .......~.....
  0140: FF FF 7E 7F 00 00 00 00 01 08 00 00 00 00 1D 07  ..~.............
  0150: 01 00 56 00 00 00 00 00 00 70 7E 7F 00 00 00 00  ..V......p~.....
  0160: FF CF 7E 7F 00 00 00 00 01 08 00 00 00 00 1D 00  ..~.............
  0170: 01 08 00 00 00 00 1D 01 01 08 00 00 00 00 1D 02  ................
  0180: 01 08 00 00 00 00 1D 03 01 0A 00 00 00 00 1C 04  ................
  0190: 00 00 01 0A 00 00 00 00 1C 04 00 02 01 0A 00 00  ................
  01A0: 00 00 1C 04 00 04 01 00 36 00 00 00 00 00 00 E0  ........6.......
  01B0: 61 7F 00 00 00 00 FF FF 61 7F 00 00 00 00 01 0A  a.......a.......
  01C0: 00 00 00 00 1C 00 00 00 01 0A 00 00 00 00 1C 04  ................
  01D0: 00 00 01 0A 00 00 00 00 1C 04 00 02 02 00 60 00  ..............`.
  01E0: 00 00 00 00 02 08 00 00 00 A0 0A 00 02 08 00 00  ................
  01F0: 00 A0 09 00 02 08 00 00 00 A0 08 00 02 08 00 00  ................
  0200: 00 A0 07 00 02 08 00 00 00 A0 06 00 02 08 00 00  ................
  0210: 00 A0 05 00 02 08 00 00 00 A0 04 00 02 08 00 00  ................
  0220: 00 A0 03 00 02 08 00 00 00 A0 02 00 02 08 00 00  ................
  0230: 00 A0 01 00 02 08 00 00 00 A0 00 00 02 00 60 00  ..............`.
  0240: 00 00 00 00 02 08 00 00 00 50 0A 00 02 08 00 00  .........P......
  0250: 00 50 09 00 02 08 00 00 00 50 08 00 02 08 00 00  .P.......P......
  0260: 00 50 07 00 02 08 00 00 00 50 06 00 02 08 00 00  .P.......P......
  0270: 00 50 05 00 02 08 00 00 00 50 04 00 02 08 00 00  .P.......P......
  0280: 00 50 03 00 02 08 00 00 00 50 02 00 02 08 00 00  .P.......P......
  0290: 00 50 01 00 02 08 00 00 00 50 00 00 02 00 58 00  .P.......P....X.
  02A0: 00 00 00 00 02 08 00 00 00 00 0A 00 02 08 00 00  ................
  02B0: 00 00 09 00 02 08 00 00 00 00 08 00 02 08 00 00  ................
  02C0: 00 00 07 00 02 08 00 00 00 00 06 00 02 08 00 00  ................
  02D0: 00 00 05 00 02 08 00 00 00 00 04 00 02 08 00 00  ................
  02E0: 00 00 03 00 02 08 00 00 00 00 02 00 02 08 00 00  ................
  02F0: 00 00 01 00                                      ....

--=-QUTXniQ2pNUL4SnRpeWD
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-QUTXniQ2pNUL4SnRpeWD--
