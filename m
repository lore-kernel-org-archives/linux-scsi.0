From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: BUG at drivers/scsi/scsi_lib.c:1113
Date: Thu, 22 Jul 2010 10:39:48 +0200
Message-ID: <4C4803D4.7050802@gmail.com>
References: <4C47ED7B.1050709@gmail.com> <20100722173716.66264bef@notabene> <20100722083609.GA4435@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100722083609.GA4435@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/22/2010 10:36 AM, Christoph Hellwig wrote:
> On Thu, Jul 22, 2010 at 05:37:16PM +1000, Neil Brown wrote:
>> I suspect that problem is that "do_sync" and "do_barriers" in
>> drivers/md/raid1.c are still 'bool' and should now be 'unsigned long'.
>>
>> I'm not sure how wide '_Bool' is, but I'm guess it isn't wide enough.
>>
>> Could you please try changing ever 'bool' in that file to 'unsigned long'
>> and see if that fixes it?
> 
> Yes, that fixes it.

For me too.

-- 
js
