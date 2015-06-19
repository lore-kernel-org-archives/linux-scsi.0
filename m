From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 8/8] target: display 'write_protect' attribute for
	demo-mode LUNs
Date: Fri, 19 Jun 2015 08:51:44 +0200
Message-ID: <20150619065143.GD1183@lst.de>
References: <1434620622-65391-1-git-send-email-hare@suse.de> <1434620622-65391-9-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1434620622-65391-9-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 18, 2015 at 11:43:42AM +0200, Hannes Reinecke wrote:
> When LUNs are mapped with a demo-mode initiator we're missing
> the 'write_protect' attribute to set a LUN read-only.

I don't think it's a good idea as-is.  The target core clearly
differenciates between demo mode and production mode read only, and some
drivers already expose attributes for these.

I have a big series in progress to clean the mess around this area
up.  So for now please don't add anything here, it should become much
simpler after my changes, and I might be able to incorporate something
like this after the main series.
