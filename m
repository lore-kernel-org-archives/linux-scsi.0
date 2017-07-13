From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCHv2] tcmu: Add fifo type waiter list support to avoid
 starvation
Date: Thu, 13 Jul 2017 00:06:20 -0500
Message-ID: <5966FFCC.7020309@redhat.com>
References: <1499843767-17420-1-git-send-email-lixiubo@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1499843767-17420-1-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: target-devel-owner@vger.kernel.org
To: lixiubo@cmss.chinamobile.com, nab@linux-iscsi.org
Cc: bryantly@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/12/2017 02:16 AM, lixiubo@cmss.chinamobile.com wrote:
> From: Xiubo Li <lixiubo@cmss.chinamobile.com>
> 
> The fifo type waiter list will hold the udevs who are waiting for the
> blocks from the data global pool. The unmap thread will try to feed the
> first udevs in waiter list, if the global free blocks available are
> not enough, it will stop traversing the list and abort waking up the
> others.
> 
> Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
>

Looks ok to me.

Reviewed-by: Mike Christie <mchristi@redhat.com>
