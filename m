From: Kashyap Desai <kashyap.desai@avagotech.com>
Subject: RE: [PATCH 1/3] megaraid_sas: Convert dev_printk to dev_<level>
Date: Tue, 27 Oct 2015 16:03:27 +0530
Message-ID: <6aed31d964ce36a682947820eee7cbc1@mail.gmail.com>
References: <1445934375-17784-1-git-send-email-wangweidong1@huawei.com>
	 <1445934375-17784-2-git-send-email-wangweidong1@huawei.com> <1445941550.16404.37.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445941550.16404.37.camel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, Weidong Wang <wangweidong1@huawei.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, JBottomley@odin.com
Cc: "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@avagotech.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> > +		dev_dbg(&instance->pdev->dev, "Error copying out
> > cmd_status\n");
> >  		error = -EFAULT;
> >  	}
> >
>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

We will consider all three patches for future submission. As of now we have
two patch set pending to be committed.
We are working for few more patch in megaraid_sas which will do clean up in
driver module + proper error handling of DCMD command timeout. It will cover
Patch posted with below subject -

[PATCH 3/3] megaraid_sas: return -ENOMEM when create DMA pool for cmd frames
failed

James  -  We will be resending these patch set on top of latest outstanding
megaraid_sas driver patch, so that we can avoid any conflict in commits.
