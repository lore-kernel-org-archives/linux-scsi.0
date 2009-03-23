From: Mark Lord <liml@rtr.ca>
Subject: Re: TRIM vs UNMAP vs WRITE SAME and thin devices
Date: Mon, 23 Mar 2009 15:23:19 -0400
Message-ID: <49C7E1A7.6050209@rtr.ca>
References: <20090123041558.GC24652@parisc-linux.org>	 <4979AF62.7070409@redhat.com>	 <1232721777.4430.7.camel@macbook.infradead.org>	 <498DA052.6090605@redhat.com>	 <1234019372.4658.9.camel@localhost.localdomain>	 <498DB350.8000905@redhat.com>	 <22BDA4D9BA18634DB0CFBB2E5A1563446F98BAE155@KFAEXMIPV1.sdcorp.global.sandisk.com> <87f94c370903231205m235402b9t6ec1c77f8bdc0857@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <87f94c370903231205m235402b9t6ec1c77f8bdc0857@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Eyal Shani <Eyal.Shani@sandisk.com>, Ric Wheeler <rwheeler@redhat.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, David Woodhouse <dwmw2@infradead.org>, "Martin K. Petersen" <mkp@mkp.net>, Matthew Wilcox <matthew@wil.cx>, Jeff Garzik <jeff@garzik.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
List-Id: linux-scsi@vger.kernel.org

..
> On Thu, Feb 12, 2009 at 9:51 AM, Eyal Shani <Eyal.Shani@sandisk.com> wrote:
>> Adding my 5 cents.
>>
>> T13 added Trim to the latest ATA8 proposal.
>> http://www.t13.org/Documents/UploadedDocuments/docs2009/d2015r1-ATAATAPI_Command_Set_-_2_ACS-2.pdf
..

Note that there is also a Rev.1a edition, same link as above
except change the d2015r1 to d2015r1a:

http://www.t13.org/Documents/UploadedDocuments/docs2009/d2015r1a-ATAATAPI_Command_Set_-_2_ACS-2.pdf
