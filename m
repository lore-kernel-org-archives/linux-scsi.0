From: Istvan Hubay Cebrian <istvan.cebrian@gmail.com>
Subject: Re: Dell Shared PERC8 RAID Controller
Date: Mon, 3 Mar 2014 17:56:04 +0000
Message-ID: <CABA7EgDUo5LZAi899-oMMnE5EkuP0GyFSQmtKtc606GG+_nAWA@mail.gmail.com>
References: <CABA7EgDjuvvwYDxzYgO1qQLjTAXbjiqccnF0CxCsJAyz+xDZ7g@mail.gmail.com>
 <20140303160944.50ba399d@harpe.intellique.com> <CABA7EgD+YaOQXEzR25NWxkH+JQ2dN1VW3RsjN3=fLdg6OOoJcQ@mail.gmail.com>
 <20140303163317.543e9a98@harpe.intellique.com> <CABA7EgABdoQK735L5uoW6ydVWpKM_rZSFcLpOCruTHEdcNu-ZA@mail.gmail.com>
 <20140303183531.7ffedbe6@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ve0-f177.google.com ([209.85.128.177]:40943 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbaCCR4Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2014 12:56:25 -0500
Received: by mail-ve0-f177.google.com with SMTP id sa20so3903885veb.8
        for <linux-scsi@vger.kernel.org>; Mon, 03 Mar 2014 09:56:24 -0800 (PST)
In-Reply-To: <20140303183531.7ffedbe6@harpe.intellique.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-scsi@vger.kernel.org

You are absolutely correct. I was on the wrong machine entirely. Sorry
(this is what lack of sleep causes). So here is what I could get from
the ESXi machine:

--

00:00:1f.2 SATA controller Mass storage controller: Intel Corporation
Patsburg 6 Port SATA AHCI Controller [vmhba0]
Class 0106: 8086:1d02

00:01:00.0 RAID bus controller Mass storage controller: LSI Logic /
Symbios Logic MegaRAID SAS SKINNY Controller [vmhba1]
Class 0104: 1000:0073

00:08:00.0 RAID bus controller Mass storage controller: LSI Logic /
Symbios Logic Shared PERC 8 Mini [vmhba2]
Class 0104: 1000:002f

--

~ # esxcli system module list
Name                           Is Loaded  Is Enabled
-----------------------------  ---------  ----------
vmkernel                            true        true
chardevs                            true        true
user                                true        true
procfs                              true        true
vfat                                true        true
vmkapi_socket                       true        true
vmkapi_v2_0_0_0_vmkernel_shim       true        true
vmkplexer                           true        true
vmklinux_9                          true        true
vmklinux_9_2_0_0                    true        true
vmklinux_9_2_1_0                    true        true
random                              true        true
usb                                 true        true
ehci-hcd                            true        true
hid                                 true        true
ipmi_msghandler                     true        true
ipmi_si_drv                         true        true
ipmi_devintf                        true        true
procMisc                            true        true
iscsi_trans                         true        true
etherswitch                         true        true
netsched                            true        true
cnic_register                       true        true
tg3                                 true        true
vmkapi_v2_0_0_0_iscsi_shim          true        true
vmci                                true        true
dell                                true        true
vmkapei                             true        true
healthchk                           true        true
teamcheck                           true        true
vlanmtucheck                        true        true
heartbeat                           true        true
shaper                              true        true
lldp                                true        true
cdp                                 true        true
ipfix                               true        true
tcpip3                              true        true
dvsdev                              true        true
vdl2                                true        true
dvfilter                            true        true
lacp                                true        true
vmkapi_v2_0_0_0_dvfilter_shim       true        true
dvfilter-generic-fastpath           true        true
vmkstatelogger                      true        true
svmmirror                           true        true
cbt                                 true        true
migrate                             true        true
esxfw                               true        true
dm                                  true        true
nmp                                 true        true
vmw_satp_local                      true        true
vmw_satp_default_aa                 true        true
vmw_psp_lib                         true        true
vmw_psp_fixed                       true        true
vmw_psp_rr                          true        true
vmw_psp_mru                         true        true
libata_92                           true        true
libata_9_2_0_0                      true        true
usb-storage                         true        true
vmkapi_v2_0_0_0_nmp_shim            true        true
hbr_filter                          true        true
libfc_92                            true        true
libfcoe_92                          true        true
libfc_9_2_0_0                       true        true
libfcoe_9_2_0_0                     true        true
ahci                                true        true
megaraid_sas                        true        true
cnic                                true        true
bnx2fc                              true        true
lvmdriver                           true        true
deltadisk                           true        true
sunrpc                              true        true
nfsclient                           true        true
vprobe                              true        true
vmkibft                             true        true
vmfs3                               true        true

~ # esxcli system module get -m megaraid_sas
   Module: megaraid_sas
   Module File: /usr/lib/vmware/vmkmod/megaraid_sas
   License: GPL
   Version: Version 06.801.52.00, Build: 472560, Interface: 9.2 Built
on: Feb  7 2013
   Signed Status: Unsigned
   Signature Issuer:
   Signature Digest: 50bd fb02 0df9 4ad0 3d99 00de 9234 f055 f7d2 f81e
aadf 7120 a941 44b3 61a6 d3b1
   Signature FingerPrint: 0000 0000 0000 0000 0000 0000 0000 0000
   Provided Namespaces:
   Required Namespaces: com.vmware.driverAPI@9.2.0.0, com.vmware.vmkapi=
@v2_0_0_0
--
Istvan Hubay Cebrian
http://icebrian.net


On 3 March 2014 17:35, Emmanuel Florac <eflorac@intellique.com> wrote:
> Le Mon, 3 Mar 2014 16:57:44 +0000
> Istvan Hubay Cebrian <istvan.cebrian@gmail.com> =E9crivait:
>
>> So I do have ESXi on one of the blade servers. Curiously "lspci -nn"
>> output is very different. I for example don't see two RAID controlle=
rs
>> but one:
>>
>> ...
>> 00:10.0 SCSI storage controller [0100]: LSI Logic / Symbios Logic
>> 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI [1000:0030] (rev 01)
>> ...
>
> Strange, do you access the shared storage in this case? Because it
> doesn't look at all like the same hardware (different PCI ids, to beg=
in
> with).
>
> --
> ---------------------------------------------------------------------=
---
> Emmanuel Florac     |   Direction technique
>                     |   Intellique
>                     |   <eflorac@intellique.com>
>                     |   +33 1 78 94 84 02
> ---------------------------------------------------------------------=
---
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
