From: <Shyam_Iyer@Dell.com>
Subject: RE: FW: [PATCH] iscsiadm: Add netconfig support in iscsiadm and
	iscsid
Date: Tue, 26 Apr 2011 07:24:01 -0700
Message-ID: <DBFB1B45AF80394ABD1C807E9F28D157032A5623AE@BLRX7MCDC203.AMER.DELL.COM>
References: <5E4F49720D0BAD499EE1F01232234BA8728AB02FEF@AVEXMB1.qlogic.org>
 <20110426112005.GY32595@reaktio.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausxippc101.us.dell.com ([143.166.85.207]:18517 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190Ab1DZOYS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Apr 2011 10:24:18 -0400
In-Reply-To: <20110426112005.GY32595@reaktio.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, harish.zunjarrao@qlogic.com



> -----Original Message-----
> From: open-iscsi@googlegroups.com [mailto:open-iscsi@googlegroups.com=
]
> On Behalf Of Pasi K=E4rkk=E4inen
> Sent: Tuesday, April 26, 2011 7:20 AM
> To: open-iscsi@googlegroups.com
> Cc: James.Bottomley@suse.de; Mike Christie; linux-scsi@vger.kernel.or=
g;
> Vikas Chaudhary; Lalit Chandivade; Ravi Anand; Harish Zunjarrao
> Subject: Re: FW: [PATCH] iscsiadm: Add netconfig support in iscsiadm
> and iscsid
>=20
> On Fri, Apr 22, 2011 at 09:24:15PM -0700, Vikas Chaudhary wrote:
> > Added open-iscsi group is CC list.
> >
> > From: Lalit Chandivade <lalit.chandivade@qlogic.com>
> >
> > 1. Current status:
> > Using iscsiadm one cannot do any network configuration for qla4xxx
> adapters.
> > However an iface is created for the qla4xxx ports using the
> hwaddress.
> >
> > \# ls /etc/iscsi/ifaces/
> > iface.example  iface0  qla4xxx.00:0e:1e:04:8b:2a
> qla4xxx.00:0e:1e:04:8b:2e
> >
> > This allows user to issue sendtargets via the qla4xxx iscsi offload=
=2E
> >
> > 2. Current Proposal:
> > Current proposal is to allow iscsiadm to configure the network
> settings for qla4xxx ports.
> >
>=20
> Hello,
>=20
> Configuring jumbo frames for qla4xxx interfaces is not supposed
> to be done using iscsiadm? One still needs qlogic (vendor) specific
> tool for that?
>=20
> Or did I miss something?
>=20
> -- Pasi
>=20

Good point.  Does changing to jumbo frames on the iSCSI function of the=
 converged adapter change the jumbo frame settings on other functions.?

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
