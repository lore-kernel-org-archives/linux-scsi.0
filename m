From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH V4 00/16] use sg helper to operate scatterlist
Date: Mon, 17 Jun 2019 16:52:25 -0700
Message-ID: <25be959c-82fc-996e-76ed-c1fe7b4dce5d@acm.org>
References: <20190617030349.26415-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20190617030349.26415-1-ming.lei@redhat.com>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, devel@driverdev.osuosl.org, Hannes Reinecke <hare@suse.com>, Benjamin Block <bblock@linux.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, James Smart <james.smart@broadcom.com>, "Ewan D . Milne" <emilne@redhat.com>, Jim Gill <jgill@vmware.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Brian King <brking@us.ibm.com>, Finn Thain <fthain@telegraphics.com.au>, "Juergen E . Fischer" <fischer@norbit.de>, Christoph Hellwig <hch@lst.de>, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 6/16/19 8:03 PM, Ming Lei wrote:
> Scsi MQ makes a large static allocation for the first scatter gather
> list chunk for the driver to use.  This is a performance headache we'd
> like to fix by reducing the size of the allocation to a 2 element
> array.  Doing this will break the current guarantee that any driver
> using SG_ALL doesn't need to use the scatterlist iterators and can get
> away with directly dereferencing the array.  Thus we need to update all
> drivers to use the scatterlist iterators and remove direct indexing of
> the scatterlist array before reducing the initial scatterlist
> allocation size in SCSI.

For all patches in this series except 9/16 and 11/16, please add the 
following:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
