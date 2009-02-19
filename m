From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [SCSI][REGRESSION][BISECTED] Disk errors loop forever in 2.6.29
Date: Thu, 19 Feb 2009 08:52:36 -0800 (PST)
Message-ID: <404514.58700.qm@web110616.mail.gq1.yahoo.com>
References: <Pine.LNX.4.44L0.0902191002160.3012-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757218AbZBSQwt@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, rjw@sisk.pl, Ingo Molnar <mingo@elte.hu>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> From: Alan Stern <stern@rowland.harvard.edu>
>
> On Thu, 19 Feb 2009, Sitsofe Wheeler wrote:
> 
> > Hi,
> > 
> > There appears to be a regression from 2.6.28 in how disk errors are
> > handled in 2.6.29rc5 - rather than trying and eventually giving up, it
> > appears to try (and report) forever. 
> 
> See this thread and patch:
> 
>     http://marc.info/?l=linux-kernel&m=123490148422684&w=2

The patch there (actually I downloaded it from http://patchwork.kernel.org/patch/7989/ )
did not make any diference. I fear my disk will soon have torn itself to bits but until then I
can trigger the error at will so I can test any patches that are suggested...



      
