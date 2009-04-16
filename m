From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] scsi_dh: Add modalias support for SCSI targets
Date: Thu, 16 Apr 2009 17:18:38 +0200
Message-ID: <49E74C4E.8030407@suse.de>
References: <20090318013615.26548.36303.sendpatchset@chandra-ubuntu>	 <20090318013621.26548.10529.sendpatchset@chandra-ubuntu>	 <ac3eb2510903181130s5dd1b1caje579d765fd338f6f@mail.gmail.com>	 <1237403902.14147.25.camel@chandra-ubuntu>	 <1237488880.26341.15.camel@chandra-ubuntu>  <49C3DF49.8050408@redhat.com>	 <1237846429.14853.6.camel@chandra-ubuntu>	 <1238798590.20924.0.camel@chandra-ubuntu>	 <1239137973.29492.12.camel@mulgrave>  <49DCBDE6.5000806@redhat.com> <1239832363.1196.5.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47129 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397AbZDPPSl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Apr 2009 11:18:41 -0400
In-Reply-To: <1239832363.1196.5.camel@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sekharan@linux.vnet.ibm.com
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Kay Sievers <kay.sievers@vrfy.org>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, Peter Jones <pjones@redhat.com>

Chandra Seetharaman wrote:
> Hi James,
>=20
> Are your concerns answered ?
>=20
> Hannes, Kay,
>=20
> Is the description related to bus notify BIND DEVICE issue clear now =
?
>=20
> Please respond :)
>=20
Yes, issue is clearer now.

Basically this is another instance where multi-driver binding would mak=
e
a difference. Using the 'notifier_chain' approach is basically doing
the very same thing whilst _not_ using driver core binding.

So from that point of view:

Acked-by: Hannes Reinecke <hare@suse.de>

However, I would really like to see it merged with my ALUA update
for scsi_dh; for ALUA matching on the vendor/product tuple is really
quite pointless and we should be using the 'TPGS' setting in
the inquiry data.

Trading your ack for mine :-)

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
