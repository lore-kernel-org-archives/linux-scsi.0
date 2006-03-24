From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC PATCH 35/35] Add Xen virtual block device
	driver.
Date: Fri, 24 Mar 2006 13:04:43 -0600
Message-ID: <442442CB.4090603@cs.wisc.edu>
References: <A95E2296287EAD4EB592B5DEEFCE0E9D4B9E8A@liverpoolst.ad.cl.cam.ac.uk>	<4421D943.1090804@garzik.org>	<1143202673.18986.5.camel@localhost.localdomain>	<4423E853.1040707@garzik.org>	<4423F60B.6020805@garzik.org>	<1143207657.2882.65.camel@laptopd505.fenrus.org>	<4423F91F.4060007@garzik.org>
	<17444.4455.240044.724257@hound.rchland.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <17444.4455.240044.724257@hound.rchland.ibm.com>
List-Unsubscribe: <http://lists.xensource.com/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: Dave C Boutcher <boutcher@cs.umn.edu>
Cc: Ian Pratt <m+Ian.Pratt@cl.cam.ac.uk>, xen-devel@lists.xensource.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, Ian Pratt <ian.pratt@xensource.com>, linux-kernel@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Arjan van de Ven <arjan@infradead.org>
List-Id: linux-scsi@vger.kernel.org

Dave C Boutcher wrote:
> Jeff Garzik wrote:
>> Arjan van de Ven wrote:
>>> On Fri, 2006-03-24 at 08:37 -0500, Jeff Garzik wrote:
>>>> Jeff Garzik wrote:
>>>>> In fact, SCSI should make a few things easier, because the notion of 
>>>>> host+bus topology is already present, and notion of messaging is already 
>>>>> present, so you don't have to recreate that in a Xen block device 
>>>>> infrastructure.
>>>> Another benefit of SCSI:  when an IBM hypervisor in the Linux kernel 
>>>> switched to SCSI, that allowed them to replace several drivers (virt 
>>>> disk, virt cdrom, virt floppy?) with a single virt-SCSI driver.
>>> but there's a generic one for that: iSCSI
>>> so in theory you only need to provide a network driver then ;)
>> Talk about lots of overhead :)
>>
>> OTOH, I bet that T10 is acting at high speed, right this second, to form 
>> a committee, and multiple sub-committees, to standardize SCSI 
>> transported over XenBus.  SXP anyone?  :)
> 
> Actually SRP (which T10 has now stopped working on) fits the bill very
> nicely.
> 

Does the IBM vscsi code/SPEC follow the SRP SPEC or is it slightly 
modified? We also have a SRP initiator in kernel now too. It is just not 
in the drivers/scsi dir.
