From: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 2/9] dmapool: cleanup error messages
Date: Fri, 3 Aug 2018 19:01:42 +0300
Message-ID: <CAHp75VdkFfND+Mr+L96kkGEF7K49Fr2HWezQQ3DBOQvxTLjBcw@mail.gmail.com>
References: <a9f7ca9a-38d5-12e2-7d15-ab026425e85a@cybernetics.com>
	<CAHp75Ve0su_S3ZWTtUEUohrs-iPiD1uzFOHhesLrWzJPOa2LNg@mail.gmail.com>
	<7a943124-c65e-f0ed-cc5c-20b23f021505@cybernetics.com>
	<b8547f8d-ac88-3d7b-9c2d-60a2f779259e@cybernetics.com>
	<CAHp75VcoLVkp+BkFBLSqn95=3SaV-zr8cO1eSoQsrzZtJZESNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <CAHp75VcoLVkp+BkFBLSqn95=3SaV-zr8cO1eSoQsrzZtJZESNQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
Cc: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chaitra P B <chaitra.basappa-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Suganath Prabu Subramani <suganath-prabu.subramani-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sathya Prakash <sathya.prakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, MPT-FusionLinux.pdl-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 3, 2018 at 6:59 PM, Andy Shevchenko
<andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Fri, Aug 3, 2018 at 6:17 PM, Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org> wrote:

>> But then I decided to simplify it to just use dev_err().  I still have
>> the old version.  When I submit v3 of the patchset, which would you prefer?
>
> JFYI: git log --no-merges --grep 'NULL device \*'

Example:

commit b4ba97e76763c4e582e3af1079e220e93b1b0d76
Author: Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>
Date:   Fri Aug 19 08:37:50 2016 +0100

   drm: Avoid calling dev_printk(.dev = NULL)



> P.S. I already shared my opinion on this anyway.

-- 
With Best Regards,
Andy Shevchenko
