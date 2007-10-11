From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Re: [PATCH] Add ALUA hardware handler
Date: Thu, 11 Oct 2007 12:47:29 -0500
Message-ID: <470E61B1.4080007@cs.wisc.edu>
References: <470CCBB0.2020904@suse.de> <470D1DAE.1000900@cs.wisc.edu>
	<470DDF6F.5090909@suse.de> <470E5B37.1060902@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <470E5B37.1060902@cs.wisc.edu>
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
Cc: Alasdair G Kergon <agk@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, christophe varoqui <christophe.varoqui@free.fr>
List-Id: linux-scsi@vger.kernel.org

Just some thoughts

Mike Christie wrote:
>> This is actually by design. Problem here is the port group as returned by
>> REPORT TARGET PORT GROUPS does not have any association to the controller
>> which handles these ports.

So I agree the hw handler just knows that it has paths unless you do 
something like chandra and send commands to figure out the contoller 
mappings. But are you saying that in userspace during dm mpath device 
setup time, there is no way to figure out the mappings? We talked about 
making the controller mappings and handling the problem where you cannot 
flood the box and the problem of having to send multiple commands more 
generic. We did not do that for rdac at the time because we thought scsi 
hw handlers were going to be done sooner, and did not want to redo the 
effort, but if it helps it could be done.
