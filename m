From: "Chris Leech" <chris.leech@gmail.com>
Subject: Re: [PATCH 1/3] 24-bit types: typedef and macros for accessing 3-byte arrays as integers
Date: Sun, 7 Sep 2008 10:52:04 -0700
Message-ID: <41b516cb0809071052t1aea47b3hd7dc40d3bb1cfce3@mail.gmail.com>
References: <20080905165732.16689.50256.stgit@localhost.localdomain>
	 <48C3A0A9.3000206@panasas.com>
	 <41b516cb0809070856v2000b93bm5305236e4a98b81a@mail.gmail.com>
	 <48C40DB4.5050007@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:37787 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003AbYIGRwF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Sep 2008 13:52:05 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1243337wfd.4
        for <linux-scsi@vger.kernel.org>; Sun, 07 Sep 2008 10:52:05 -0700 (PDT)
In-Reply-To: <48C40DB4.5050007@panasas.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Harvey Harrison <harvey.harrison@gmail.com>

On Sun, Sep 7, 2008 at 10:21 AM, Boaz Harrosh <bharrosh@panasas.com> wrote:
> I wanted to see what you're saying and tried this test code below:
>
> <test.c>
>
> I get the exact same assembly.
>
> What am I doing wrong ?

Interesting.  My earlier comparisons were done in the kernel and
comparing the resulting libicssi.o and iscsi_tcp.o.  Let me look into
this more.

Chris
