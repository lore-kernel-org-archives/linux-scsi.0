From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: [PATCH] block: Revert "[SCSI] genhd: add a new attribute "alias"
 in gendisk"
Date: Thu, 24 Nov 2011 13:21:53 +0100
Message-ID: <4ECE36E1.20809@itwm.fraunhofer.de>
References: <20111109162512.GB1260@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111109162512.GB1260@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/09/2011 05:25 PM, Tejun Heo wrote:
> This reverts commit a72c5e5eb738033938ab30d6a634b74d1d060f10.
>
> The commit introduced alias for block devices which is intended to be
> used during logging although actual usage hasn't been committed yet.
> This approach adds very limited benefit (raw log might be easier to
> follow) which can be trivially implemented in userland but has a lot
> of problems.
>

I have asked this before, but have been entirely ignored. So again, how 
do do you want to implement it in user space, if you are monitoring a 
system over a serial line, so all kernel messages go over that serial 
line to another system, without any local user space being involved?

Thanks,
Bernd
