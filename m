From: Don Brace <brace77070@gmail.com>
Subject: Re: [PATCH 1 22/25] hpsa: enhance device messages
Date: Mon, 2 Nov 2015 10:54:27 -0600
Message-ID: <56379543.7000907@pmcs.com>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220644.5323.17616.stgit@brunhilda> <56337F81.1040403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f194.google.com ([209.85.214.194]:36680 "EHLO
	mail-ob0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbbKBQy3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2015 11:54:29 -0500
Received: by obctp1 with SMTP id tp1so8598233obc.3
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2015 08:54:28 -0800 (PST)
In-Reply-To: <56337F81.1040403@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 10/30/2015 09:32 AM, Tomas Henzl wrote:
> RAID_UNKNOWN is used in few other places - raid_level_show for example,

raid_level_show handles physical devices by using "N/A", otherwise it 
displays
the RAID level for logical devices.

Other functions avoid the use of raid_type when the drive is not a RAID 
device.

Or, am I missing your point?

