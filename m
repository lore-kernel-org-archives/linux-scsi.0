From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: Re: [PATCH] configfs: Fix race between create_link and configfs_rmdir
Date: Thu, 8 Jun 2017 07:34:05 -0500
Message-ID: <c76cb2bd-726b-7334-ae74-f2870390efb6@linux.vnet.ibm.com>
References: <1496897514-20142-1-git-send-email-nab@linux-iscsi.org>
 <20170608072129.GA13433@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170608072129.GA13433@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Joel Becker <jlbec@evilplan.org>
List-Id: linux-scsi@vger.kernel.org


> Thanks Nic,
>
> applied to the configfs-for-next tree.  I'm not entirely sure if we
> should bother adding this to 4.12 or if it hits rarely enough?
>
It hits for us pretty often when we have a GPFS setup with 10 hosts and 1k+ vms.

That is how we discovered the bug in the first place.

-Bryant
