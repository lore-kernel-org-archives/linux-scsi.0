From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: RE: 3ware and scsi ids
Date: 03 Jun 2003 23:23:19 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1054678998.9234.80.camel@dhcp22.swansea.linux.org.uk>
References: <12C3C1794982613-01@MMS__ad.corp.aoltw.net_>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc2-cwma1-4-cust86.swan.cable.ntl.com ([213.105.254.86]:18562
	"EHLO lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S261864AbTFCXHk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jun 2003 19:07:40 -0400
In-Reply-To: <12C3C1794982613-01@MMS__ad.corp.aoltw.net_>
List-Id: linux-scsi@vger.kernel.org
To: "Deas, Jim" <James.Deas@warnerbros.com>
Cc: linux-scsi@vger.kernel.org

On Maw, 2003-06-03 at 23:16, Deas, Jim wrote:
> I have never seen labels in the raidtab.
> fstab yes. raidtab no. Is it possible?
> Is this a better solution than LVM?
> LVM seem to insert yet another layer.
> I would like to avoid that if possible.

Ah sorry I misunderstood your original message slightly.

raidtab doesn't have any labels. This might be useful
however. The Dell guys wrote a tool that generates consistant
naming using device serial info

	http://www.lerhaupt.com/devlabel/


