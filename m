From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/12] target: Convert se_node_acl->device_list[] to
	RCU hlist
Date: Tue, 19 May 2015 08:22:31 +0200
Message-ID: <20150519062231.GB29468@lst.de>
References: <1431422736-29125-1-git-send-email-nab@daterainc.com> <1431422736-29125-2-git-send-email-nab@daterainc.com> <20150513063555.GA21770@lst.de> <1431506771.26897.78.camel@haakon3.risingtidesystems.com> <20150517165142.GA17217@lst.de> <1431933444.24645.7.camel@haakon3.risingtidesystems.com> <20150518074102.GA6157@lst.de> <20150518080155.GA6451@lst.de> <1432015547.9093.76.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1432015547.9093.76.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, May 18, 2015 at 11:05:47PM -0700, Nicholas A. Bellinger wrote:
> > [   12.830576] kernel BUG at ../drivers/target/target_core_device.c:337!
> > 
> 
> How did you hit this..?

tcm_node --block iblock_0/array /dev/sda

line=$(tcm_loop --createnexus=0)
wwn=$(echo $line | awk '{print $15}')
tcm_loop --addlun=$wwn 0 0 iblock_0/array
