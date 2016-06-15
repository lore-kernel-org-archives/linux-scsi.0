From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: Re: [PATCH v4] ibmvscsis: Initial commit of IBM VSCSI Tgt Driver
Date: Wed, 15 Jun 2016 18:43:23 -0500
Message-ID: <AB54FB5D-BD11-408E-B7EE-D6A951C50964@linux.vnet.ibm.com>
References: <1464409675.22249.237.camel@haakon3.risingtidesystems.com>
 <1465507614-29695-1-git-send-email-bryantly@linux.vnet.ibm.com>
 <9680e172-4646-1cfc-fbc8-5b47a168040b@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <9680e172-4646-1cfc-fbc8-5b47a168040b@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, nab@linux-iscsi.org, hch@infradead.org
Cc: mikecyr@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, akpm@linux-foundation.org, gregkh@linuxfoundation.org, joe@perches.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

On 6/14/16, 3:09 AM, "Bart Van Assche" <bart.vanassche@sandisk.com> wrote:

>On 06/09/2016 11:26 PM, Bryant G. Ly wrote:
>> This driver is a pick up of the old IBM VIO scsi Target Driver
>> that was started by Nick and Fujita 2-4 years ago.
>> http://comments.gmane.org/gmane.linux.scsi/90119
>
>What kernel version is this patch based on? It doesn't apply cleanly on 
>top of kernel v4.7-rc1 nor on top of kernel v4.6.
>

It should be for 4.5, but latest version I based it off 4.6 stable. So you should look at that one.

-Bryant
