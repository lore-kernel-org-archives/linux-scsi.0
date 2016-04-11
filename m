From: Varun Prakash <varun@chelsio.com>
Subject: Re: [PATCH v2 07/16] iscsi-target: add int
 (*iscsit_validate_params)()
Date: Mon, 11 Apr 2016 23:14:13 +0530
Message-ID: <20160411174410.GA1758@chelsio.com>
References: <cover.1460204441.git.varun@chelsio.com>
 <1b7a0271cf70d869a26fc042ab2b123afeb1c8ad.1460204441.git.varun@chelsio.com>
 <570A925F.6080003@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <570A925F.6080003@grimberg.me>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com
List-Id: linux-scsi@vger.kernel.org

On Sun, Apr 10, 2016 at 08:50:23PM +0300, Sagi Grimberg wrote:
> 
> >Add int (*iscsit_validate_params)() to
> >struct iscsit_transport, iscsi-target
> >uses this callback for validating
> >conn operational parameters.
> 
> Again, why is this needed?

This is for updating the value of
MAXXMITDATASEGMENTLENGTH to the value supported
by the adapter.
I will update the commit log in -v3.
