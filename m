From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH-v2 0/4] target: Eliminate se_port + t10_alua_tg_pt_gp_member
Date: Tue, 26 May 2015 14:44:14 +0200
Message-ID: <55646A9E.5050401@sandisk.com>
References: <1432623445-25776-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1432623445-25776-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 05/26/15 08:57, Nicholas A. Bellinger wrote:
>    - Add various rcu_dereference and lockless_dereference RCU notation

Hello Nic,

Feedback from an RCU expert (which I'm not) would be appreciated here. 
But my understanding is that lockless_dereference(p) should be used for 
a pointer p that has *not* been annotated as an RCU pointer. I think in 
the for-next branch of the target repository that this macro is used to 
access RCU-annotated pointers. Is that why sparse complains about how 
lockless_dereference() is used in the target tree ?

Bart.
