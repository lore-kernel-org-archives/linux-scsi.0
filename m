From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] scsi: delete decade+ obsolete aic7xxx_old driver
Date: Tue, 17 Sep 2013 16:27:54 -0400
Message-ID: <5238BB4A.8000309@redhat.com>
References: <y687fpks4kdsmfuadq4cykip.1379384036544@email.android.com>  <52386730.4060508@suse.de> <1379448641.2213.18.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1379448641.2213.18.camel@dabdike>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, Paul Gortmaker <paul.gortmaker@windriver.com>, linux-scsi list <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/17/13 16:10, James Bottomley wrote:

> OK, so do we have any real evidence that no-one uses this driver?  Does
> any distro actually compile it, for instance?

Red Hat doesn't use it in any of their products (and it hasn't been the
preferred driver since about the old Red Hat Linux 7.0 days).


-- 
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford
