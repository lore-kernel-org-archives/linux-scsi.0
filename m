From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 0/9] target: se_node_acl + se_lun RCU conversions
Date: Mon, 25 May 2015 15:01:55 -0700
Message-ID: <1432591315.722.7.camel@haakon3.risingtidesystems.com>
References: <1432275071-28882-1-git-send-email-nab@daterainc.com>
	 <555F01C3.3020301@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <555F01C3.3020301@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2015-05-22 at 12:15 +0200, Bart Van Assche wrote:
> On 05/22/15 08:11, Nicholas A. Bellinger wrote:
> > Here is -v2 series for converting LIO target se_node_acl + se_lun
> > mapping tables from fixed size arrays to dynamic RCU hlist_heads.
> 
> The full list of new sparse warnings introduced by this patch series for
> source files under drivers/target is as follows:

Yes, I'm aware this needs the associated RCU notation to make sparse
happy. 
