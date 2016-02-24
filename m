From: Sahil Malhotra <sahil.malhotra@nxp.com>
Subject: Query regarding "libcxgbi/cxgb4i : Fix ipv6 build failure caught with
 randconfig" patch
Date: Wed, 24 Feb 2016 05:25:19 +0000
Message-ID: <HE1PR04MB08736B010C37AFECE329DD1A82A50@HE1PR04MB0873.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-db3on0085.outbound.protection.outlook.com ([157.55.234.85]:64704
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756510AbcBXFZX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2016 00:25:23 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Sandeep Malik <sandeep.malik@nxp.com>

Hi,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 In reference to below pat=
ch.
	http://permalink.gmane.org/gmane.linux.network/326310

	I have a query that why this patch selects NETDEVICES on the basis of =
IPv6 being compiled as a module or not ?
	Please help on this.

Regards,
Sahil Malhotra


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
