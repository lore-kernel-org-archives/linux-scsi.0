From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 03/10] staging: fnic2 add fip handling
Date: Fri, 6 Apr 2018 07:08:59 +0200
Message-ID: <20180406050859.GE27591@kroah.com>
References: <20180405211519.GA12584@osmithde-lnx.cisco.com>
 <20180405211837.GD12584@osmithde-lnx.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180405211837.GD12584@osmithde-lnx.cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oliver Smith-Denny <osmithde@cisco.com>
Cc: Sesidhar Baddela <sebaddel@cisco.com>, Gian Carlo Boffa <gcboffa@cisco.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 05, 2018 at 02:18:37PM -0700, Oliver Smith-Denny wrote:
> --- /dev/null
> +++ b/drivers/staging/fnic2/src/fip.c
> @@ -0,0 +1,804 @@
> +/*
> + * SPDX-License-Identifier: GPL-2.0
> + * Copyright 2018 Cisco Systems, Inc.  All rights reserved.
> + *
> + * This program is free software; you may redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +/*! \file */

What is that line for?
