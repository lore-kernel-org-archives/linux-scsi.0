From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 16/32] scsi/be2iscsi,qla2xxx: convert to alloc_workqueue()
Date: Wed, 02 Feb 2011 14:41:22 -0600
Message-ID: <4D49C172.3040600@cs.wisc.edu>
References: <1294062595-30097-1-git-send-email-tj@kernel.org> <1294062595-30097-17-git-send-email-tj@kernel.org> <4D489B09.9010906@cs.wisc.edu> <20110202102521.GA24115@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110202102521.GA24115@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jayamohan Kallickal <jayamohank@serverengines.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 02/02/2011 04:25 AM, Tejun Heo wrote:
> usually necessary.  The queue of pending works tend to be short and
> consumed pretty fast.
>

What if we want to do something that could take a while, like doing 
recovery of a device/transport (so you have to send resets and 
logouts/logins and wait for the results but they could take a while if 
they timeout), should we be using something other than a workqueue so it 
does not interfere with other users?
