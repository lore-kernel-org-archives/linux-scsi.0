From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/12] target: TPG/NodeACL LUN table conversion to RCU
	hlist
Date: Wed, 13 May 2015 08:29:46 +0200
Message-ID: <20150513062946.GA21657@lst.de>
References: <1431422736-29125-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1431422736-29125-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

Thanks, I like this approach.  Getting rid of the array defintively helps,
and while I don't think the linked list will be enough to scale in the
long run the actual data structure is abstracted away from most code
(even more so with the remaining review comment fixed), so even if
we need to move to a tree or hash structure in the future that should
be easy to manage.
