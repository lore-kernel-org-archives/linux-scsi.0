From: Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] - SMR Modifications to EXT4 (and other
 generic file systems)
Date: Wed, 07 Jan 2015 09:57:47 -0500
Message-ID: <54AD496B.8080708@oracle.com>
References: <CAKdFiL6CMHTHWCvSFjFNw6hzvPLDEWWAC-o3wdivq9co7SX1FA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19834 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbbAGO5x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jan 2015 09:57:53 -0500
In-Reply-To: <CAKdFiL6CMHTHWCvSFjFNw6hzvPLDEWWAC-o3wdivq9co7SX1FA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Palmer <adrian.palmer@seagate.com>, lsf-pc@lists.linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On 01/06/2015 06:29 PM, Adrian Palmer wrote:
> I'd like to host a discussion of SMRFFS and ZAC for consumer and cloud
> systems at LSF/MM. I want to gather community consensus at LSF/MM of the
> required technical kernel changes before this topic is presented at Vault.
> 
> Subtopics:
> 
> On-disk metadata structures and data algorithms
> Explicit in-order write requirement and a look at the IO stack
> New IOCTLs to call from the FS and the need to know about the underlying
> disk -- no longer completely disk agnostic

Where can we read about the details of SMRFFS before LSF/MM / Vault?


Thanks,
Sasha
