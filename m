From: Olaf Hering <olaf@aepfle.de>
Subject: Re: [PATCH 1/1] scsi: storvsc: Fix a build issue reported by kbuild
 test robot
Date: Thu, 28 Jan 2016 16:56:13 +0100
Message-ID: <20160128155613.GA12447@gmail.com>
References: <1453966147-10568-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1453966147-10568-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com, martin.petersen@oracle.com, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 27, K. Y. Srinivasan wrote:

> +	depends on SCSI_FC_ATTRS

I think 'depends' instead of 'select' will cause HYPERV_STORAGE to
disapepar during make oldconfig if SCSI_FC_ATTRS was not set before.
Not sure what the policy of 'depends' vs.  'select' actually is.  If
SCSI_FC_ATTRS is supposed to be a library kind of thing then 'select'
might be the correct way.

Olaf
