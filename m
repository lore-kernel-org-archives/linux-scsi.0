From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCHSET 2.6.26-rc8] block: implement extended devt
Date: Thu, 3 Jul 2008 07:28:21 -0600
Message-ID: <20080703132821.GE14894@parisc-linux.org>
References: <1215073986-4709-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1215073986-4709-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, jens.axboe@oracle.com, viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org, device@lanana.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 03, 2008 at 05:33:00PM +0900, Tejun Heo wrote:
> I chose major 259 at my own whim.  Is it okay to use this value?  As

No.  You need to get it assigned by LANANA (Torben Mathiasen
<device@lanana.org>).  See Documentation/devices.txt.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
