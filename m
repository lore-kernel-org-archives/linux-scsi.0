From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] Remove SCSI_BH
Date: Sun, 16 Jun 2002 22:22:01 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020616.222201.105585133.davem@redhat.com>
References: <20020616192253.Q9435@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020616192253.Q9435@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: willy@debian.org
Cc: torvalds@transmeta.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

   From: Matthew Wilcox <willy@debian.org>
   Date: Sun, 16 Jun 2002 19:22:53 +0100
   
   Hi, Linus.  This patch switches SCSI from a bottom half to a tasklet.
   It's been reviewed, tested & approved by Andrew Morton, James Bottomley &
   Doug Gilbert.  Please apply.

I always wanted to make this a per-cpu SOFTIRQ, there is no reason
it can't be and it's important enough to deserve to be one.
