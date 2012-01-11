From: Xi Wang <xi.wang@gmail.com>
Subject: Re: aacraid question: is maximum_num_containers supposed to be minimum?
Date: Wed, 11 Jan 2012 03:38:55 -0500
Message-ID: <8654A042-17CA-4C02-8F34-554ED55B34F4@gmail.com>
References: <20120111082842.GA31452@elgon.mountain>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120111082842.GA31452@elgon.mountain>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, Haogang Chen <haogangchen@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Jan 11, 2012, at 3:28 AM, Dan Carpenter wrote:
> MAXIMUM_NUM_CONTAINERS is consistently used as a minimum not a maximum
> so I was wondering what was up with that?  This is ancient code that
> predates git.

Check out some early discussion. ;-)

https://lkml.org/lkml/2011/12/3/85

- xi
