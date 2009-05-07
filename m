From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/3] scsi_dh: Remove the workqueue used for
	activate
Date: Wed, 06 May 2009 22:32:43 -0500
Message-ID: <4A02565B.9060105@cs.wisc.edu>
References: <20090428025230.11108.88559.sendpatchset@chandra-ubuntu>
	<20090428025242.11108.43024.sendpatchset@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090428025242.11108.43024.sendpatchset@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Chandra Seetharaman wrote:
> Since scsi_dh_activate() has become an asynchronous function,
> we do not need a workqueue for submitting scsi_dh_activate().
> 
> This patch just removes the workqueue that submits scsi_dh_activate().
> 

Before this is merged, we need to convert the other device handlers to 
use blk_execute_rq_nowait or use their own workqueue_struct right?
