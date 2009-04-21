From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/2] Evaluate TGPS setting for device handler detection
Date: Tue, 21 Apr 2009 08:24:04 +0200
Message-ID: <49ED6684.4080601@suse.de>
References: <20090319080642.4815418C79D@pentland.suse.de> <1239899445.1196.12.camel@chandra-ubuntu> <49ECE046.6060109@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:54433 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbZDUGYJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2009 02:24:09 -0400
In-Reply-To: <49ECE046.6060109@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: sekharan@linux.vnet.ibm.com, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Peter Jones <pjones@redhat.com>

Hi Mike,

Mike Christie wrote:
> Chandra Seetharaman wrote:
>>>  static const struct scsi_dh_devlist alua_dev_list[] =3D {
>>> -    {"HP", "MSA VOLUME" },
>>> -    {"HP", "HSV101" },
>>> -    {"HP", "HSV111" },
>>> -    {"HP", "HSV200" },
>>> -    {"HP", "HSV210" },
>>> -    {"HP", "HSV300" },
>>> -    {"IBM", "2107900" },
>>> -    {"IBM", "2145" },
>>> -    {"Pillar", "Axiom" },
>>> -    {"Intel", "Multi-Flex"},
>>> -    {NULL, NULL}
>>> +    {"", "", 3 },
>>> +    {NULL, NULL, 0}
>>>  };
>=20
> Is this going to make problems for the what the module alias patches
> were trying to do?
>=20
> Will userspace have to check for the mod alias stuff for scsi_dh_emc,
> scsi_dh_hp and scsh_dh_rdac, then for scsh_dh_alua does it check for =
the
> scsi devices sysfs tpgts file to see if ALUA is support?
Well, these patch actually precedes the modalias support, so obviously
we'll have to rework that to take everything (devtype, tpgs, vendor, mo=
del)
into account.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
