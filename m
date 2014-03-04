From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH 4/6] iser-target: Fix post_send_buf_count for RDMA READ/WRITE
Date: Tue, 4 Mar 2014 09:49:50 +0200
Message-ID: <5315859E.7050202@mellanox.com>
References: <1393891265-22910-1-git-send-email-nab@daterainc.com> <1393891265-22910-5-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1393891265-22910-5-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 04/03/2014 02:01, Nicholas A. Bellinger wrote:
> This is necessary because even though IB_SEND_SIGNALED is
> not set for RDMA WRITEs + READs, during a QP failure event
> the work requests will be returned with exception status
> from the TX completion queue.

Impossible... for rdma reads we must ask for completing, since we should 
write the data
for the back-end, I assume it's just wrong mentioning of rdma-read here, 
right?
