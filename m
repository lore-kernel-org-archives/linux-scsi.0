From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 2/2] scsi: storvsc: Add support for FC lightweight host.
Date: Sun, 22 Jan 2017 22:24:06 +0300
Message-ID: <20170122192406.GJ4454@mwanda>
References: <1484771338-8903-1-git-send-email-cavery@redhat.com>
 <1484771338-8903-3-git-send-email-cavery@redhat.com>
 <20170118231555.GC4454@mwanda> <5880FD8F.8020608@redhat.com>
 <20170120093116.GH4398@mwanda> <5884FF21.3050801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <5884FF21.3050801@redhat.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Cathy Avery <cavery@redhat.com>
Cc: jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, haiyangz@microsoft.com, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Jan 22, 2017 at 01:51:13PM -0500, Cathy Avery wrote:
> I'm sorry.  In my zeal to push out this patch I have done a poor job
> of communication on a number of levels.
> 
> The first patch which deals with the fc transport changes will not
> set the scsi_transport_template.eh_timed_out function directly
> during lightweight fc_attach_transport(). It instead relies on
> whatever was indicated as the scsi_host_template timeout handler
> during inscsi_times_out() scsi_error.c.
> 
> So yes in a sense it is related but now I believe I understand your
> point. Perhaps this would fall more under the heading of post
> fc_transport implementation storvsc cleanup necessitating its own
> patch.
> 
> I will break it out in the next go round.

Ah...  Actually it probably belongs in this patch, it just wasn't
obvious to me how they were related (I'm a total newbie with this code
so that's probably part of the confusion).  Since you're resend the code
anyway, could you just add this information to the commit message?

regards,
dan carpenter
