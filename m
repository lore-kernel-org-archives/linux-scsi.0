From: "S. J. van Harmelen" <svh@dds.nl>
Subject: Re: [PATCH 0/3] Workqueue framework and ALUA hardware
	handler
Date: Mon, 19 Nov 2007 08:51:56 +0100
Message-ID: <1195458716.5873.1.camel@sanderbal>
References: <473C0DD0.7080702@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <473C0DD0.7080702@suse.de>
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
Cc: Mike Christie <michaelc@cs.wisc.edu>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi Hannes,

Can you tell me when these patches get in the kernel? Is that going to
be 2.6.24.x or can we expect them before that?

Sander



On Thu, 2007-11-15 at 10:13 +0100, Hannes Reinecke wrote:
> Hi all,
> 
> this patchset adds some more abstraction to the multipath
> hardware handlers.
> - A generic workqueue framework is added, which allows the
>   hardware handler to submit failover commands independent
>   from multipath I/O.
> - The exsting RDAC hardware handler is converted to use that
>   framework
> - A new SPC-3 ALUA hardware handler is added, using that
>   framework
> - A controller abstraction is added to the framework, which
>   allows for command throttling based on the used controller.
> - The RDAC hardware handler is modified to use the new
>   controller framework.
> 
> This patchset superseded my previous implementation of the
> SPC-3 ALUA handler.
> Next plans are to update the table definitions and multipath-tools
> to allow for a passing of the controller ID from userland; ALUA
> doesn't specify for any controller information, so we have to
> do this by hand based on prior knowledge of the storage array.
> 
> As per normal, comments etc welcome.
> 
> Cheers,
> 
> Hannes
