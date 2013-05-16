From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH V1 7/7] Drivers: scsi: storvsc: Increase the value of
 STORVSC_MAX_IO_REQUESTS
Date: Thu, 16 May 2013 15:02:00 +0300
Message-ID: <20130516120200.GN1360@mwanda>
References: <1368706784-32276-1-git-send-email-kys@microsoft.com>
 <1368706879-32321-1-git-send-email-kys@microsoft.com>
 <1368706879-32321-7-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1368706879-32321-7-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/devel>,
 <mailto:devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/devel/>
List-Post: <mailto:devel@linuxdriverproject.org>
List-Help: <mailto:devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/devel>,
 <mailto:devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: devel-bounces@linuxdriverproject.org
Sender: "devel" <devel-bounces@linuxdriverproject.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org, jasowang@redhat.com, ohering@suse.com, jbottomley@parallels.com, linux-kernel@vger.kernel.org, hch@infradead.org, apw@canonical.com, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

On Thu, May 16, 2013 at 05:21:19AM -0700, K. Y. Srinivasan wrote:
> Increase the value of STORVSC_MAX_IO_REQUESTS to 200 requests. The current
> ringbuffer size can support this higher value.
> 

The ringbuffer size is a module parameter so it's odd to talk about
the "current" size.

regards,
dan carpenter
