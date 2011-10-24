From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: No linkage from /sys entries for a given scsi_host to its PCI
 device details?
Date: Mon, 24 Oct 2011 10:03:42 +0200
Message-ID: <1319443422.7777.1.camel@dabdike>
References: <S932680Ab1INNeE/20110914133404Z+1759@vger.kernel.org>
	 <E4D7778E36CF944ABD2F7E18D2DB9666271B897A1A@inbmail02.lsi.com>
	 <E4D7778E36CF944ABD2F7E18D2DB9666271B897A1B@inbmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46721 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753608Ab1JXIDs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2011 04:03:48 -0400
In-Reply-To: <E4D7778E36CF944ABD2F7E18D2DB9666271B897A1B@inbmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Sampathkumar, Kishore" <Kishore.SampathKumar@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2011-10-24 at 13:20 +0530, Sampathkumar, Kishore wrote:
> From the above, there is no linkage to the PCI device corresponding to
> the above host controller. The only way I could establish the linkage
> was to actually start from the PCI device ID for this controller, and
> then, doing the following: 

I do 

ls -l /sys/class/scsi_host

To get this:

lrwxrwxrwx 1 root root 0 Oct 24 09:25 host0
-> ../../devices/pci0000:00/0000:00:1f.2/host0/scsi_host/host0/
lrwxrwxrwx 1 root root 0 Oct 24 09:25 host1
-> ../../devices/pci0000:00/0000:00:1f.2/host1/scsi_host/host1/
lrwxrwxrwx 1 root root 0 Oct 24 09:25 host2
-> ../../devices/pci0000:00/0000:00:1f.2/host2/scsi_host/host2/
lrwxrwxrwx 1 root root 0 Oct 24 09:25 host3
-> ../../devices/pci0000:00/0000:00:1f.2/host3/scsi_host/host3/
lrwxrwxrwx 1 root root 0 Oct 24 09:25 host4
-> ../../devices/pci0000:00/0000:00:1f.2/host4/scsi_host/host4/
lrwxrwxrwx 1 root root 0 Oct 24 09:25 host5
-> ../../devices/pci0000:00/0000:00:1f.2/host5/scsi_host/host5/

Which allows an easy link back.

James


