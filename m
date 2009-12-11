From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Re: [PATCH] Always pass result and sense on request
	completion
Date: Fri, 11 Dec 2009 01:32:48 -0600
Message-ID: <4B21F5A0.1040008@cs.wisc.edu>
References: <20091119122454.71A7D3A174@ochil.suse.de>		<4B20C417.4020201@suse.de>
	<1260463457.2457.80.camel@mulgrave.site>
	<4B213084.1010200@panasas.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4B213084.1010200@panasas.com>
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
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Boaz Harrosh wrote:
> 
> I agree that the req->errors bits where not understood outside of scsi
> up till now. Is multipath only compatible over scsi block devices?
> 

It works with any device that has a request_queue and implements 
queueing functions like the request_fn. It should work with DASD I think.
