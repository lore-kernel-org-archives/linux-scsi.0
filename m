From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT from
 the basic I/O timeout
Date: Fri, 18 Jul 2014 10:00:30 -0700
Message-ID: <20140718170030.GA31769@infradead.org>
References: <1401899623-24194-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1401899623-24194-1-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org, jasowang@redhat.com, ohering@suse.com, jbottomley@parallels.com, linux-kernel@vger.kernel.org, hch@infradead.org, apw@canonical.com, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 04, 2014 at 09:33:43AM -0700, K. Y. Srinivasan wrote:
> Commit ID: 7e660100d85af860e7ad763202fff717adcdaacd added code to derive the
> FLUSH_TIMEOUT from the basic I/O timeout. However, this patch did not use the
> basic I/O timeout of the device. Fix this bug.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

Looks good to me,

Reviewed-by: Christoph Hellwig <hch@lst.de>

(it will need some changes to apply to my tree, but I'm happy to do that
if I can get another review).

James, does this look fine to you?
