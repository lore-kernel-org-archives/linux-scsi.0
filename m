From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] 7/7 fix single_lun code for per-scsi_device queue_lock
Date: Wed, 26 Mar 2003 17:12:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E8225B0.2020805@splentec.com>
References: <20030324175337.A14957@beaverton.ibm.com> <20030324175422.A14996@beaverton.ibm.com> <20030324180227.A15047@beaverton.ibm.com> <20030324180247.B15047@beaverton.ibm.com> <20030324180304.C15047@beaverton.ibm.com> <20030324180325.D15047@beaverton.ibm.com> <20030324180341.E15047@beaverton.ibm.com> <20030324180404.F15047@beaverton.ibm.com> <3E80C8DD.4060803@splentec.com> <20030326134717.B5307@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> 
> OK will add comments, though undecided on whether to have both a
> target lock and host_lock, or just go with host_lock (per comments sent
> reply to James).

You must recognize that this is the same concern as James'.

It's a really important one for all the headaches and lock ups
it could bring if not well documented.

This is just the nature of ``locking hierarchies''.

-- 
Luben


