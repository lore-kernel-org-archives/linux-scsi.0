From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET 2.6.26-rc8] block: implement extended devt
Date: Fri, 04 Jul 2008 00:54:46 +0900
Message-ID: <486CF646.9090208@kernel.org>
References: <1215073986-4709-1-git-send-email-tj@kernel.org> <20080703132821.GE14894@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080703132821.GE14894@parisc-linux.org>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, jens.axboe@oracle.com, viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org, device@lanana.org
List-Id: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Jul 03, 2008 at 05:33:00PM +0900, Tejun Heo wrote:
>> I chose major 259 at my own whim.  Is it okay to use this value?  As
> 
> No.  You need to get it assigned by LANANA (Torben Mathiasen
> <device@lanana.org>).  See Documentation/devices.txt.

Yeap, already cc'd && the question was sorta directed to LANANA.  :-)

-- 
tejun
